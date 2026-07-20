---
name: shortcut-visualizer
description: |-
  Create or update a visual keymap for a shortcut device, and keep it synchronized with Karabiner-Elements mappings.
  Triggers: a user asks to visualize shortcut assignments, create or update a keypad/keyboard/controller cheat sheet, show assigned versus unassigned keys, create a shortcut diagram, or prepare a keymap for a desktop overlay.
  Do not trigger: ordinary Karabiner shortcut changes that do not require a visual, general brainstorming about shortcut assignments, or a request to inspect an existing mapping without creating or updating its visual representation.
---

# Shortcut Visualizer

Create a physical-layout keymap that lets the user identify a shortcut without opening its configuration.

## Workflow

1. Read the active shortcut configuration and inspect the device layout image when available.
2. Treat the physical layout as authoritative. Do not substitute a generic numpad or keyboard arrangement.
3. List every visible key. Mark each as assigned, unassigned, or intentionally left as a standard key.
4. Use a short action label and an icon only when it speeds recognition.
5. Update the shortcut configuration and the keymap in the same change. Do not leave a diagram stale.
6. Validate the configuration syntax and render or inspect the visual before handing it off.

## Visual rules

- Preserve physical key sizes, including tall `+` and `Enter` keys, wide `0`, and separate navigation clusters.
- Group persistent meanings consistently: app/web launch, window layout, system action, and unassigned/standard key.
- Use labels that describe the result, such as `スリープ`, `左 1/3`, or `日本語翻訳`; avoid implementation details such as shell command names.
- Mark unassigned keys clearly. Do not fill every key merely to make the diagram look complete.
- Prefer the installed application's icon over a web logo. Read `CFBundleIconFile` from the application's `Info.plist`, convert the `.icns` asset to a small PNG when required, and keep the visual self-contained when it must render outside the local filesystem.
- Keep the visual usable in light and dark themes and ensure labels do not overlap at narrow widths.

## Source of truth

- Treat `karabiner/karabiner.json` as the behavior source of truth.
- Keep a repository-owned keymap source for any desktop overlay. Thread-scoped inline visual files are suitable for conversation display but are not runtime assets.
- When an action needs a friendly label or icon that cannot be inferred from the Karabiner rule, record that display metadata beside the repository-owned keymap source.

## Output targets

### Inline conversation visual

Use the `visualize` skill. Follow its fragment, accessibility, rendering, and response-directive requirements.

### Desktop overlay

Use the same physical layout and display metadata as the inline visual. The overlay must not steal keyboard focus or accept mouse input unless the user explicitly asks for interaction.

## Validation

Run all applicable checks:

```sh
jq -e . karabiner/karabiner.json
'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli' --select-profile 'Default profile' --silent
git diff --check
```

For an inline visual, render the HTML fragment with the `visualize` skill's `render.py`. For an overlay, verify that it starts, receives a show command, receives a hide command, and leaves the frontmost application focused.
