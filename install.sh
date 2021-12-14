#!/bin/sh

# http://osxdaily.com/2014/02/12/install-command-line-tools-mac-os-x/ homebrewのときに勝手に入るしわざわざ指定しなくても良さそう
# xcode-select --install


brew -v
if [ $? -gt 0 ]; then
    echo "homebrew does not exit"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" #homebrewのインストール
fi

# commnad line tools
brew install fish tmux tree htop reattach-to-user-namespace pyenv wget bat docker #rmtrash #rmtrash無くなった疑惑

# install application
brew install --cask visual-studio-code karabiner-elements google-chrome iterm2 docker slack cheatsheet clipy notion

# とりあえずインストールしないかもしれないやつら
# brew install --cask cacher mendeley-desktop mactex
# 詳しくはhttps://texwiki.texjp.org/?TeX%20Live%2FMac#texlive-install-brew

## python
#brew install python3
#
## xonsh
#pip3 install xonsh
#pip3 install gnureadline
#pip3 install prompt-toolkit
#pip3 install pygments

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

