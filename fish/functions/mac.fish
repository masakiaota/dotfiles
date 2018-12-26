#bash経由で起動するようにするのでここらへんの設定が不要になった
#起動の高速化のため、python3と打ったらデフォルトをpython3に変更。以降pythonで3が起動する。
# function p3
#     set PYENV_ROOT $HOME/.pyenv

#     # なぜかMBAにはbinがないのに動く(エラーがうざいので空でmkdirした)
#     set PATH $PYENV_ROOT/bin $PATH
#     . (pyenv init - | psub);
#     . (pyenv virtualenv-init - | psub); and python -V;
#     which python;
# end

# function notebook
#     set PYENV_ROOT $HOME/.pyenv
#     # なぜかMBAにはbinがないのに動く(エラーがうざいので空でmkdirした)
#     set PATH $PYENV_ROOT/bin $PATH
#     . (pyenv init - | psub);
#     . (pyenv virtualenv-init - | psub); and jupyter notebook $argv
# end

#alias
## rmでゴミ箱に入れる
## brew install rmtrash
alias rmt='rmtrash'

#現在のdirをfinderで開く
alias finder="open ."

# 日本語を含むdir名とか深い階層へのアクセスが面倒なので
set drive ~/Documents/OneDrive