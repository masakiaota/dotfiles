# Match the interactive Bash -> fish workflow described in README.md.
# Keep Bash usable until fish is installed, and leave scripts unaffected.
export PATH="$HOME/.local/bin:$PATH"

case $- in
    *i*)
        if command -v fish >/dev/null 2>&1; then
            exec fish
        fi
        ;;
esac
