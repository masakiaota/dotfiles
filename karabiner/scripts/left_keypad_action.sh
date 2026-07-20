#!/bin/sh

# Invoked by Satechi Bluetooth Keypad rules in karabiner.json.
set -eu

web_apps_dir="$HOME/Applications/Brave Browser Apps.localized"

case "${1-}" in
    codex)
        /usr/bin/open -b com.openai.codex
        ;;
    brave)
        /usr/bin/open -b com.brave.Browser
        ;;
    vscode)
        /usr/bin/open -b com.microsoft.VSCode
        ;;
    iterm)
        /usr/bin/open -b com.googlecode.iterm2
        ;;
    chatgpt)
        /usr/bin/open "$web_apps_dir/ChatGPT.app"
        ;;
    reminders)
        /usr/bin/open -b com.apple.reminders
        ;;
    calendar)
        /usr/bin/open -b com.apple.iCal
        ;;
    youtube)
        /usr/bin/open "$web_apps_dir/YouTube.app"
        ;;
    prime_video)
        /usr/bin/open 'https://www.amazon.co.jp/gp/video/mystuff/watchlist/tv/?ref_=atv_mys_wl_tab'
        ;;
    finder)
        /usr/bin/osascript <<'APPLESCRIPT'
tell application "Finder"
    if (count of Finder windows) is 0 then make new Finder window
    activate
end tell
APPLESCRIPT
        ;;
    translate_to_japanese)
        /usr/bin/osascript <<'APPLESCRIPT'
set clipboardMarker to "__SATECHI_TRANSLATE_SELECTION__"
set originalClipboard to the clipboard
set the clipboard to clipboardMarker

tell application "System Events" to keystroke "c" using {command down}

set selectedText to clipboardMarker
repeat 20 times
    delay 0.05
    try
        set selectedText to the clipboard as text
    on error
        set selectedText to clipboardMarker
    end try
    if selectedText is not clipboardMarker then exit repeat
end repeat

if selectedText is clipboardMarker then
    set the clipboard to originalClipboard
    display notification "翻訳するテキストを選択してから実行してください" with title "Satechi keypad"
    error number -128
end if

set lineBreak to linefeed
set promptText to "次の <to_translate> と </to_translate> の間にある文章だけを、自然な日本語に翻訳してください。" & lineBreak & "説明・要約・原文の再掲は不要です。翻訳文だけを出力してください。" & lineBreak & lineBreak & "<to_translate>" & lineBreak & selectedText & lineBreak & "</to_translate>"
set the clipboard to promptText
APPLESCRIPT

        chatgpt_bundle_id=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' \
            "$web_apps_dir/ChatGPT.app/Contents/Info.plist")
        /usr/bin/open "$web_apps_dir/ChatGPT.app"
        /usr/bin/osascript - "$chatgpt_bundle_id" <<'APPLESCRIPT'
on run argv
    set targetBundleID to item 1 of argv
    tell application "System Events"
        set targetProcess to missing value
        repeat 60 times
            try
                set targetProcess to first application process whose bundle identifier is targetBundleID
                set frontmost of targetProcess to true
                if frontmost of targetProcess then exit repeat
            end try
            delay 0.05
        end repeat

        if targetProcess is missing value then error "ChatGPT did not become available"

        delay 0.1
        keystroke "o" using {command down, shift down}
        delay 0.3
        keystroke "v" using {command down}
    end tell
end run
APPLESCRIPT
        ;;
    *)
        exit 64
        ;;
esac
