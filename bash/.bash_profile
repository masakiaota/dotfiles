#初期状態らしい
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
# 起動時に一回だけ読み込まれるfileらしい

# Added by Antigravity
export PATH="/Users/masaki/.antigravity/antigravity/bin:$PATH"
. "$HOME/.cargo/env"
