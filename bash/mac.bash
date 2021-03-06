#環境変数
export PATH="/bin/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export PATH=$HOME/.nodebrew/current/bin:$PATH


function pyenv_init(){
        #pyenv
        echo "starting pyenv"
        export PYENV_ROOT="$HOME/.pyenv"
        if [ -d ${PYENV_ROOT} ]; then
          export PATH="$PYENV_ROOT/bin:$PATH"
          eval "$(pyenv init -)"
          if [ -d ${PYENV_ROOT}/plugins/pyenv-virtualenv ]; then
            eval "$(pyenv virtualenv-init -)"
          fi
        fi
}

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


