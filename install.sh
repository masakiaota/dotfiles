#!/bin/sh


brew -v
if [ $? -gt 0 ]; then
    echo "homebrew does not exit"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" #homebrewのインストール
fi

brew install fish
brew install tmux

if [ -e ~/.tmux/plugins/tpm ]; then
    # 存在する場合
    echo "tpm may have been already installed"
else
    # 存在しない場合
    echo "installing tmp..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ -e ~/.vim/autoload/plug.vim ]; then
    # 存在する場合
    echo "vim-plug may have been already installed"
else
    # 存在しない場合
    echo "installing vim-plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

