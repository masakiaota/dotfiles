# エイリアスやシェル関数を定義するためのもの
export LANG=ja_JP.UTF-8

#プロンプトの見た目を見やすくする
PS1="\n[\u@\h]
\W
\$ "


# OSで条件分岐
case "$OSTYPE" in
  darwin*)
    echo "OSX"
    source ~/dotfiles/bash/mac.bash
    # forlab
    source ~/.lab.bash
    ;; 
  linux*)
    echo "LINUX"
    source ~/dotfiles/bash/linux.bash
    ;;
  bsd*)     echo "BSD" ;;
  msys*)    echo "WINDOWS" ;;
  *)        echo "unknown: $OSTYPE" ;;
esac



# if [ "$(uname)" == "Darwin" ]; then
#     echo "your OS is "$OSTYPE
#     source ~/dotfiles/bash/mac.bash
# fi


echo "starting fish"
if ! fish; then
    "fish is not installed. starting xonsh"
    xonsh
fi
#echo "starting xonsh..."
#xonsh