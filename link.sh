#!/bin/sh

#fishの設定
echo "setting fish..."
cd ~/.config/
mv fish/ fish.bak/
ln -s ~/dotfiles/fish
cp fish.bak/fishd.* ~/dotfiles/fish/ #既存の設定の継承

#tmux
echo "setting tmux..."
cd
ln -s ~/dotfiles/.tmux.conf

#vim
echo "setting vim..."
ln -s ~/dotfiles/.vimrc

#vscode
echo "setting vscode..."
if [ -e ~/Library/Application\ Support/Code/User ]; then
    # 存在する場合
    cd ~/Library/Application\ Support/Code/User
    ln -s ~/dotfiles/vscode/keybindings.json
    ln -s ~/dotfiles/vscode/settings.json
else
    # 存在しない場合
    echo "vscode has not been installed"
fi

echo "Please refer to README.md, in orderto activate some extensions."