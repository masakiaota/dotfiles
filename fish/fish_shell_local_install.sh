#!/bin/bash

# from  https://gist.github.com/masih/10277869
# Script for installing Fish Shell on systems without root access.
# Fish Shell will be installed in $HOME/local/bin.
# It's assumed that wget and a C/C++ compiler are installed.

#コンパイラがうまく動かなかったときに記述した
# export CC=gcc-8
# export CXX=gcc-8
# export ARCHFLAGS="-arch x86_64"
# alias gcc=gcc-8
# alias g++=g++-8

# exit on error
set -e
 
FISH_SHELL_VERSION=3.0.2
#https://github.com/fish-shell/fish-shell/releases/download/3.0.1/fish-3.0.1.tar.gz 
# create our directories
mkdir -p $HOME/local $HOME/fish_shell_tmp
cd $HOME/fish_shell_tmp
 
# download source files for Fish Shell
# wget http://fishshell.com/files/${FISH_SHELL_VERSION}/fish-${FISH_SHELL_VERSION}.tar.gz
wget https://github.com/fish-shell/fish-shell/releases/download/${FISH_SHELL_VERSION}/fish-${FISH_SHELL_VERSION}.tar.gz

# extract files, configure, and compile

tar xvzf fish-${FISH_SHELL_VERSION}.tar.gz
cd fish-${FISH_SHELL_VERSION}
./configure --prefix=$HOME/local --disable-shared

mkdir build; cd build
cmake .. #-DWITH_GETTEXT=OFF #Macではこれをコメントアウトしないとうまくいかない
make
make install
