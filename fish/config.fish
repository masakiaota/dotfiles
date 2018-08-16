#起動の高速化のため、python3と打ったらデフォルトをpython3に変更。以降pythonで3が起動する。
#dirは /Users/{ユーザー名}/.config/fish
function p3
    set PYENV_ROOT $HOME/.pyenv 
    
    # なぜかMBAにはbinがないのに動く(エラーがうざいので空でmkdirした)
    set PATH $PYENV_ROOT/bin $PATH
    . (pyenv init - | psub); 
    . (pyenv virtualenv-init - | psub); and python -V;
    which python;
end

function notebook
    set PYENV_ROOT $HOME/.pyenv 
    
    # なぜかMBAにはbinがないのに動く(エラーがうざいので空でmkdirした)
    set PATH $PYENV_ROOT/bin $PATH
    . (pyenv init - | psub); 
    . (pyenv virtualenv-init - | psub); and jupyter notebook $argv
end


## rmでゴミ箱に入れる
## brew install rmtrash
alias rm='rmtrash'

# encoding
# -xのオプションがついてる例をよく見るが起動時に読み込まれるから別に永続化させる必要もない
set LANG ja_JP.UTF-8


#cd後にls 
function cd
    builtin cd $argv; and ls
end


# gitがめんどくさいので
function gitlazy
    git add .;
    git commit -m "$argv";
    git push;
end


# git打つのがめんどくさいので
alias gpl='git pull'

#現在のdirをfinderで開く
alias finder="open ."

# tmux a
alias ta = "tmux a"
# 日本語を含むdir名とか深い階層へのアクセスが面倒なので
set lab ./OneDrive/研究室/
