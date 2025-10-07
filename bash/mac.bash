#環境変数
export PATH="/bin/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export PATH=$HOME/.nodebrew/current/bin:$PATH

case $- in
    *i*)#インタラクティブモードの処理をこの中に書く。

       # for bash_completion
       if [ -f `brew --prefix`/etc/bash_completion ]; then
         source `brew --prefix`/etc/bash_completion
       fi

        ;;
     #*) return;;
esac

# alias


