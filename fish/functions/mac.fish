
#本当はintaractiveモードのときだけ実行するというふうに書いたほうがいいのだろうが。
set -x PYENV_ROOT $HOME/.pyenv

# なぜかMBAにはbinがないのに動く(エラーがうざいので空でmkdirした)
set -x PATH $PYENV_ROOT/bin $PATH
. (pyenv init - | psub);
. (pyenv virtualenv-init - | psub);
echo 'your python env is'
pyenv versions;


#alias
## rmでゴミ箱に入れる
## brew install rmtrash
alias rmt='rmtrash'

#現在のdirをfinderで開く
alias finder="open ."

# 日本語を含むdir名とか深い階層へのアクセスが面倒なので
set drive ~/Documents/OneDrive