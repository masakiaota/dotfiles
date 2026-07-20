#import <AppKit/AppKit.h>
#import <ApplicationServices/ApplicationServices.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <math.h>
#import <stdio.h>
#import <stdlib.h>
#import <string.h>
#import <sysexits.h>

// The Accessibility API and Core Graphics both use global screen coordinates
// whose origin is the top-left corner of the main display.  Keep all window
// placement calculations in that coordinate space.

typedef struct {
    CGDirectDisplayID identifier;
    CGRect bounds;
    CGRect visibleBounds;
} Display;

static void printRect(const char *name, CGRect rect) {
    fprintf(stdout, "%s=%.0f,%.0f,%.0f,%.0f\n", name, rect.origin.x, rect.origin.y,
            rect.size.width, rect.size.height);
}

static BOOL readAXRect(AXUIElementRef element, CFStringRef attribute, AXValueType type,
                       void *value) {
    CFTypeRef attributeValue = NULL;
    AXError error = AXUIElementCopyAttributeValue(element, attribute, &attributeValue);
    if (error != kAXErrorSuccess || attributeValue == NULL) {
        return NO;
    }

    BOOL success = CFGetTypeID(attributeValue) == AXValueGetTypeID() &&
                   AXValueGetType(attributeValue) == type &&
                   AXValueGetValue(attributeValue, type, value);
    CFRelease(attributeValue);
    return success;
}

static AXUIElementRef copyFocusedWindow(pid_t *outPID) {
    AXUIElementRef system = AXUIElementCreateSystemWide();
    if (system == NULL) {
        return NULL;
    }

    CFTypeRef appValue = NULL;
    AXError error = AXUIElementCopyAttributeValue(
        system, kAXFocusedApplicationAttribute, &appValue);
    CFRelease(system);
    if (error != kAXErrorSuccess || appValue == NULL ||
        CFGetTypeID(appValue) != AXUIElementGetTypeID()) {
        if (appValue != NULL) {
            CFRelease(appValue);
        }
        return NULL;
    }

    AXUIElementRef app = (AXUIElementRef)appValue;
    if (outPID != NULL) {
        AXUIElementGetPid(app, outPID);
    }

    CFTypeRef windowValue = NULL;
    error = AXUIElementCopyAttributeValue(app, kAXFocusedWindowAttribute, &windowValue);
    if (error != kAXErrorSuccess || windowValue == NULL) {
        if (windowValue != NULL) {
            CFRelease(windowValue);
        }
        windowValue = NULL;
        error = AXUIElementCopyAttributeValue(app, kAXMainWindowAttribute, &windowValue);
    }
    CFRelease(app);

    if (error != kAXErrorSuccess || windowValue == NULL ||
        CFGetTypeID(windowValue) != AXUIElementGetTypeID()) {
        if (windowValue != NULL) {
            CFRelease(windowValue);
        }
        return NULL;
    }

    return (AXUIElementRef)windowValue;
}

static NSScreen *screenForDisplay(CGDirectDisplayID displayID) {
    for (NSScreen *screen in NSScreen.screens) {
        NSNumber *screenNumber = screen.deviceDescription[@"NSScreenNumber"];
        if (screenNumber != nil && screenNumber.unsignedIntValue == displayID) {
            return screen;
        }
    }
    return nil;
}

static CGRect visibleBoundsForDisplay(CGDirectDisplayID displayID, CGRect displayBounds) {
    NSScreen *screen = screenForDisplay(displayID);
    if (screen == nil) {
        return displayBounds;
    }

    NSRect frame = screen.frame;
    NSRect visibleFrame = screen.visibleFrame;
    if (frame.size.width <= 0 || frame.size.height <= 0) {
        return displayBounds;
    }

    // NSScreen uses an AppKit coordinate system.  Derive only edge insets from
    // it, then apply them to CGDisplayBounds.  This avoids a global-origin
    // conversion, which is unreliable with mirrors and scaled resolutions.
    CGFloat xScale = displayBounds.size.width / frame.size.width;
    CGFloat yScale = displayBounds.size.height / frame.size.height;
    CGFloat leftInset = (NSMinX(visibleFrame) - NSMinX(frame)) * xScale;
    CGFloat rightInset = (NSMaxX(frame) - NSMaxX(visibleFrame)) * xScale;
    CGFloat topInset = (NSMaxY(frame) - NSMaxY(visibleFrame)) * yScale;
    CGFloat bottomInset = (NSMinY(visibleFrame) - NSMinY(frame)) * yScale;

    CGRect visibleBounds = CGRectMake(CGRectGetMinX(displayBounds) + leftInset,
                                      CGRectGetMinY(displayBounds) + topInset,
                                      displayBounds.size.width - leftInset - rightInset,
                                      displayBounds.size.height - topInset - bottomInset);
    if (visibleBounds.size.width <= 0 || visibleBounds.size.height <= 0) {
        return displayBounds;
    }
    return visibleBounds;
}

static Display *copyActiveDisplays(size_t *outCount) {
    uint32_t displayCount = 0;
    if (CGGetActiveDisplayList(0, NULL, &displayCount) != kCGErrorSuccess || displayCount == 0) {
        return NULL;
    }

    CGDirectDisplayID *identifiers = calloc(displayCount, sizeof(CGDirectDisplayID));
    if (identifiers == NULL) {
        return NULL;
    }

    uint32_t actualCount = 0;
    if (CGGetActiveDisplayList(displayCount, identifiers, &actualCount) != kCGErrorSuccess ||
        actualCount == 0) {
        free(identifiers);
        return NULL;
    }

    Display *displays = calloc(actualCount, sizeof(Display));
    if (displays == NULL) {
        free(identifiers);
        return NULL;
    }

    for (uint32_t index = 0; index < actualCount; index++) {
        displays[index].identifier = identifiers[index];
        displays[index].bounds = CGDisplayBounds(identifiers[index]);
        displays[index].visibleBounds = visibleBoundsForDisplay(
            identifiers[index], displays[index].bounds);
    }
    free(identifiers);
    *outCount = actualCount;
    return displays;
}

static CGFloat intersectionArea(CGRect first, CGRect second) {
    CGRect intersection = CGRectIntersection(first, second);
    if (CGRectIsNull(intersection) || CGRectIsEmpty(intersection)) {
        return 0;
    }
    return intersection.size.width * intersection.size.height;
}

static size_t displayIndexForWindow(const Display *displays, size_t count, CGRect windowBounds) {
    size_t selectedIndex = 0;
    CGFloat largestArea = 0;
    for (size_t index = 0; index < count; index++) {
        CGFloat area = intersectionArea(windowBounds, displays[index].bounds);
        if (area > largestArea) {
            largestArea = area;
            selectedIndex = index;
        }
    }
    if (largestArea > 0) {
        return selectedIndex;
    }

    CGPoint pointer = CGPointZero;
    CGEventRef pointerEvent = CGEventCreate(NULL);
    if (pointerEvent != NULL) {
        pointer = CGEventGetLocation(pointerEvent);
        CFRelease(pointerEvent);
    }
    for (size_t index = 0; index < count; index++) {
        if (CGRectContainsPoint(displays[index].bounds, pointer)) {
            return index;
        }
    }

    CGDirectDisplayID mainDisplay = CGMainDisplayID();
    for (size_t index = 0; index < count; index++) {
        if (displays[index].identifier == mainDisplay) {
            return index;
        }
    }
    return 0;
}

static CGRect targetBounds(CGRect visibleBounds, const char *layout) {
    CGFloat left = round(CGRectGetMinX(visibleBounds));
    CGFloat firstBoundary = round(CGRectGetMinX(visibleBounds) + visibleBounds.size.width / 3.0);
    CGFloat secondBoundary = round(CGRectGetMinX(visibleBounds) + visibleBounds.size.width * 2.0 / 3.0);
    CGFloat right = round(CGRectGetMaxX(visibleBounds));
    CGFloat top = round(CGRectGetMinY(visibleBounds));
    CGFloat bottom = round(CGRectGetMaxY(visibleBounds));

    if (strcmp(layout, "left") == 0) {
        return CGRectMake(left, top, firstBoundary - left, bottom - top);
    }
    if (strcmp(layout, "center") == 0) {
        return CGRectMake(firstBoundary, top, secondBoundary - firstBoundary, bottom - top);
    }
    if (strcmp(layout, "left_two_thirds") == 0) {
        return CGRectMake(left, top, secondBoundary - left, bottom - top);
    }
    if (strcmp(layout, "right_two_thirds") == 0) {
        return CGRectMake(firstBoundary, top, right - firstBoundary, bottom - top);
    }
    return CGRectMake(secondBoundary, top, right - secondBoundary, bottom - top);
}

static BOOL setWindowBounds(AXUIElementRef window, CGRect bounds) {
    CGPoint origin = bounds.origin;
    CGSize size = bounds.size;
    AXValueRef sizeValue = AXValueCreate(kAXValueCGSizeType, &size);
    AXValueRef positionValue = AXValueCreate(kAXValueCGPointType, &origin);
    if (sizeValue == NULL || positionValue == NULL) {
        if (sizeValue != NULL) {
            CFRelease(sizeValue);
        }
        if (positionValue != NULL) {
            CFRelease(positionValue);
        }
        return NO;
    }

    // macOS can constrain a window before and after it crosses a display edge.
    // The same size → position → size sequence is used by mature window
    // managers to make the final frame deterministic.
    AXError sizeError = AXUIElementSetAttributeValue(window, kAXSizeAttribute, sizeValue);
    AXError positionError = AXUIElementSetAttributeValue(window, kAXPositionAttribute, positionValue);
    AXError finalSizeError = AXUIElementSetAttributeValue(window, kAXSizeAttribute, sizeValue);
    CFRelease(sizeValue);
    CFRelease(positionValue);
    return sizeError == kAXErrorSuccess && positionError == kAXErrorSuccess &&
           finalSizeError == kAXErrorSuccess;
}

static void printUsage(void) {
    fprintf(stderr,
            "usage: left_keypad_window_layout [--inspect] "
            "left|center|right|left_two_thirds|right_two_thirds\n");
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        BOOL inspect = NO;
        const char *layout = NULL;
        if (argc == 2) {
            layout = argv[1];
        } else if (argc == 3 && strcmp(argv[1], "--inspect") == 0) {
            inspect = YES;
            layout = argv[2];
        } else {
            printUsage();
            return EX_USAGE;
        }
        if (strcmp(layout, "left") != 0 && strcmp(layout, "center") != 0 &&
            strcmp(layout, "right") != 0 && strcmp(layout, "left_two_thirds") != 0 &&
            strcmp(layout, "right_two_thirds") != 0) {
            printUsage();
            return EX_USAGE;
        }
        if (!AXIsProcessTrusted()) {
            fprintf(stderr, "Accessibility permission is required.\n");
            return EX_NOPERM;
        }

        // NSScreen is used only to obtain per-display safe-area insets.
        [[NSApplication sharedApplication] setActivationPolicy:NSApplicationActivationPolicyProhibited];

        pid_t focusedPID = 0;
        AXUIElementRef window = copyFocusedWindow(&focusedPID);
        if (window == NULL) {
            fprintf(stderr, "No focused window is available.\n");
            return EX_UNAVAILABLE;
        }

        CGPoint windowOrigin = CGPointZero;
        CGSize windowSize = CGSizeZero;
        BOOL gotPosition = readAXRect(window, kAXPositionAttribute, kAXValueCGPointType, &windowOrigin);
        BOOL gotSize = readAXRect(window, kAXSizeAttribute, kAXValueCGSizeType, &windowSize);
        if (!gotPosition || !gotSize || windowSize.width <= 0 || windowSize.height <= 0) {
            fprintf(stderr, "The focused window cannot be positioned or sized.\n");
            CFRelease(window);
            return EX_UNAVAILABLE;
        }
        CGRect windowBounds = CGRectMake(windowOrigin.x, windowOrigin.y,
                                         windowSize.width, windowSize.height);

        size_t displayCount = 0;
        Display *displays = copyActiveDisplays(&displayCount);
        if (displays == NULL) {
            fprintf(stderr, "No active display is available.\n");
            CFRelease(window);
            return EX_UNAVAILABLE;
        }

        size_t displayIndex = displayIndexForWindow(displays, displayCount, windowBounds);
        CGRect destination = targetBounds(displays[displayIndex].visibleBounds, layout);

        if (inspect) {
            fprintf(stdout, "focused_pid=%d\n", focusedPID);
            printRect("window", windowBounds);
            fprintf(stdout, "selected_display=%u\n", displays[displayIndex].identifier);
            printRect("display", displays[displayIndex].bounds);
            printRect("visible", displays[displayIndex].visibleBounds);
            printRect("target", destination);
            for (size_t index = 0; index < displayCount; index++) {
                fprintf(stdout, "display_%zu=%u\n", index, displays[index].identifier);
                printRect("  bounds", displays[index].bounds);
                printRect("  visible", displays[index].visibleBounds);
                printRect("  target", targetBounds(displays[index].visibleBounds, layout));
            }
        }

        BOOL moved = setWindowBounds(window, destination);
        free(displays);
        CFRelease(window);
        if (!moved) {
            fprintf(stderr, "The focused window rejected the requested frame.\n");
            return EX_UNAVAILABLE;
        }
    }
    return EXIT_SUCCESS;
}
