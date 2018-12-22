#dirは /Users/{ユーザー名}/.config/fish

# encoding
# -xのオプションがついてる例をよく見るが起動時に読み込まれるから別に永続化させる必要もない
set LANG ja_JP.UTF-8


#cd後にls
# function cd
#     builtin cd $argv; and ls
# end

# alias
# gitがめんどくさいので
function gitlazy
    git commit -m "$argv";
    git push;
end

# git打つのがめんどくさいので
alias gpl='git pull'

# alias
alias ta="tmux a"
# alias ll="ls -lha"
# alias la="ls -a" #これらはデフォでonになってた... 恐るべしfish
alias l="ls -a"
alias note="jupyter notebook"
alias lab="jupyter lab"

# OS enveronment
echo OS is (uname)
switch (uname)
case Darwin
    source ~/dotfiles/fish/functions/mac.fish
case Linux
    echo Linux is not set preference
case FreeBSD NetBSD DragonFly
    echo BSD is not set preference
case '*'
    echo Hi, stranger!
end


