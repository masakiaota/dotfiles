# エイリアスやシェル関数を定義するためのもの
export LANG=ja_JP.UTF-8

case $- in
    *i*)#インタラクティブモードの処理をこの中に書く。
        #まずはfishやxonshの起動を試みる。
        echo "starting fish"
        if ! exec fish; then
            echo "fish is not installed. starting xonsh"
            xonsh
        fi
        reset
        #プロンプトの見た目を見やすくする
PS1="\n[\u@\h]
\W
\$ "


        ;;
      #*) return;;
esac




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

# #コンパイラがうまく動かなかったときに記述した
# export CC=gcc-8
# export CXX=gcc-8
# export ARCHFLAGS="-arch x86_64"
# alias gcc=gcc-8
# alias g++=g++-8


