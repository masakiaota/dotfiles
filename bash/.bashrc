# エイリアスやシェル関数を定義するためのもの
export LANG=ja_JP.UTF-8
#if [[ "$OSTYPE" == "linux-gnu" ]]; then
    #export PATH=$PATH:/home/lab/masaki/.linuxbrew/bin
#fi

case $- in
    *i*)#インタラクティブモードの処理をこの中に書く。
        #まずはfishやxonshの起動を試みる。
        echo "starting fish"
        if type "fish" > /dev/null 2>&1; then
            #コマンドが存在する時の処理
            exec fish
        else
            echo "fish is not exist!" #コマンドが存在しないときの処理
        fi
        ;;
      #*) return;;
esac

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

# #コンパイラがうまく動かなかったときに記述した
# export CC=gcc-8
# export CXX=gcc-8
# export ARCHFLAGS="-arch x86_64"
# alias gcc=gcc-8
# alias g++=g++-8


