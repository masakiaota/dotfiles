export LANG=ja_JP.UTF-8

if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# user-local binaries (e.g. uv installed by the official installer)
export PATH="$HOME/.local/bin:$PATH"

[ -r "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# 対話シェルだけ、表示と対話用設定を読み込む
case $- in
    *i*) ;;
    *) return ;;
esac

# プロンプト
PS1="\n[\u@\h]\n\W\n\$ "

# OSで条件分岐
if [ -t 1 ]; then
    case "$OSTYPE" in
        darwin*)
            echo "OSX"
            [ -r "$HOME/dotfiles/bash/mac.bash" ] && . "$HOME/dotfiles/bash/mac.bash"
            ;;
        linux*)
            echo "LINUX"
            [ -r "$HOME/dotfiles/bash/linux.bash" ] && . "$HOME/dotfiles/bash/linux.bash"
            ;;
        bsd*) echo "BSD" ;;
        msys*) echo "WINDOWS" ;;
        *) echo "unknown: $OSTYPE" ;;
    esac
fi
