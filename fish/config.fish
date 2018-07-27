#起動の高速化のため、python3と打ったらデフォルトをpython3に変更。以降pythonで3が起動する。
#dirは /Users/{ユーザー名}/.config/fish
function py3
    #set -x PATH $HOME/.pyenv/ $PATH
    . (pyenv init - | psub); 
    . (pyenv virtualenv-init - | psub); and python $argv
end



# cd > ls
# function cd
#   builtin cd $argv
#   ls -a
# end

## rmでゴミ箱に入れる
## brew install rmtrash
alias rm='rmtrash'

# encoding
set -x LANG ja_JP.UTF-8

#gitのbranch名出す
function git_branch
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
end

#右prompt
function fish_right_prompt
    echo -n (date "+%H:%M:%S")
    echo (git_branch)
end

# cd後にls 
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

# 日本語を含むdir名とか深い階層へのアクセスが面倒なので
set lab ./OneDrive/研究室/
