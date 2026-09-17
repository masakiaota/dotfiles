# ログインシェルでも共通の Bash 設定を読み込む
if [ -r "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
