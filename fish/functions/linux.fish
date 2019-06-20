#set -x PATH /home/lab/masaki/.linuxbrew/bin $PATH
#本当はintaractiveモードのときだけ実行するというふうに書いたほうがいいのだろうが。
set -x PYENV_ROOT $HOME/.pyenv

# なぜかMBAにはbinがないのに動く(エラーがうざいので空でmkdirした)
set -x PATH $PYENV_ROOT/bin $PATH
. (pyenv init - | psub);
. (pyenv virtualenv-init - | psub);

echo "pyenv activate anaconda3-4.3.1 for ubuntu"
pyenv global anaconda3-4.3.1

echo 'your python env is'
pyenv versions;


#alias
