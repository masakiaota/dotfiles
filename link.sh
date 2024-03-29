#!/bin/sh

# karabiner
echo "setting karabiner ? (yes/no)"
read ans
case $ans in
    yes)
    cd ~/.config
    mv karabiner karabiner.bak
    ln -s ~/dotfiles/karabiner
    ;;
    *)
    echo "skip";;
esac

echo

#bashの設定
echo "setting bash"
cd
mv .bashrc bashrc.old
mv .bash_profile bash_profile.old
ln -s ~/dotfiles/bash/.bashrc
ln -s ~/dotfiles/bash/.bash_profile

echo

#fishの設定
echo "setting fish..."
cd ~/.config/fish
mv config.fish config.fish.old
mv functions functions.old
ln -s ~/dotfiles/fish/config.fish
ln -s ~/dotfiles/fish/functions
# cp fish.bak/fishd.* ~/dotfiles/fish/ #既存の設定の継承

echo
#hyper
# echo "setting hyper..."
# cd
# ln -sf ~/dotfiles/.hyper.js

# echo
# #xonsh
# echo "setting xonsh..."
# cd
# ln -s ~/dotfiles/.xonshrc

echo

#tmux
echo "setting tmux..."
cd
ln -s ~/dotfiles/.tmux.conf

echo

#vim
echo "setting vim..."
cd
ln -s ~/dotfiles/.vimrc

echo

# #vscode 最近は自動同期で便利
# echo "setting vscode ? (yes/no)"
# read ans
# case $ans in
#     yes)
#     if [ -e ~/Library/Application\ Support/Code/User ]; then
#         # 存在する場合
#         cd ~/Library/Application\ Support/Code/User
#         ln -s ~/dotfiles/vscode/keybindings.json
#         ln -s ~/dotfiles/vscode/settings.json
#     else
#         # 存在しない場合
#         echo "vscode has not been installed"
#     fi
#     ;;
#     *)
#     echo "skip";;
# esac
# echo "Please refer to README.md, in orderto activate some extensions."