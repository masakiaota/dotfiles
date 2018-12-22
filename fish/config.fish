#dirは /Users/{ユーザー名}/.config/fish

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


# encoding
# -xのオプションがついてる例をよく見るが起動時に読み込まれるから別に永続化させる必要もない
set LANG ja_JP.UTF-8


#cd後にls
# function cd
#     builtin cd $argv; and ls
# end

# alias
## rmでゴミ箱に入れる
## brew install rmtrash
alias rm='rmtrash'

# gitがめんどくさいので
function gitlazy
    git commit -m "$argv";
    git push;
end


# git打つのがめんどくさいので
alias gpl='git pull'

#現在のdirをfinderで開く
alias finder="open ."


# alias
alias ta="tmux a"
# alias ll= "ls -lha"
# alias la= "ls -a" #これらはデフォでonになってた... 恐るべしfish
alias l="ls -a"
alias note="jupyter notebook"
alias lab="jupyter lab"

# 日本語を含むdir名とか深い階層へのアクセスが面倒なので
set drive ~/Documents/OneDrive

