#!/bin/sh
# Build the native helper once after cloning or changing its Objective-C source.
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

exec /usr/bin/xcrun clang -O2 -fobjc-arc \
  -framework AppKit \
  -framework ApplicationServices \
  "$script_dir/left_keypad_window_layout.m" \
  -o "$script_dir/left_keypad_window_layout"
