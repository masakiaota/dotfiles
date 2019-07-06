
#本当はintaractiveモードのときだけ実行するというふうに書いたほうがいいのだろうが。
set -x PYENV_ROOT $HOME/.pyenv

# なぜかMBAにはbinがないのに動く(エラーがうざいので空でmkdirした)
set -x PATH $PYENV_ROOT/bin $PATH
. (pyenv init - | psub);
. (pyenv virtualenv-init - | psub);
echo 'your python env is'
pyenv versions;

set -x PATH /usr/local/bin /usr/local/sbin $PATH

#alias
## rmでゴミ箱に入れる
## brew install rmtrash
alias rmt='rmtrash'

#現在のdirをfinderで開く
alias finder="open ."

# 日本語を含むdir名とか深い階層へのアクセスが面倒なので
set drive ~/Documents/OneDrive


# kaggle kernel docker
alias kaggle_lab='docker run -v $PWD:/tmp/working -w=/tmp/working -p 8888:8888 --rm -it gcr.io/kaggle-images/python:v61  jupyter lab --no-browser --ip="0.0.0.0" --notebook-dir=/tmp/working --allow-root'
alias kaggle_ipy='docker run -v $PWD:/tmp/working -w=/tmp/working --rm -it gcr.io/kaggle-images/python:v61 ipython'