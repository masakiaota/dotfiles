# エイリアスやシェル関数を定義するためのもの
export LANG=ja_JP.UTF-8

#プロンプトの見た目を見やすくする
PS1="\n[\u@\h]
\W
\$ "

if [ "$(uname)" == "Darwin" ]; then
    echo "your OS is "$OSTYPE
    source ~/dotfiles/bash/bash_mac
fi


echo "starting fish"
if ! fish; then
    "fish is not installed. starting xonsh"
    xonsh
fi
#echo "starting xonsh..."
#xonsh