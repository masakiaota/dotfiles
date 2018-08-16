### 戒め
* 環境構築に必要以上に時間をかけるのは時間の無駄。
* 自分の把握しきれない設定は存在しないも同じ。
* 必要最低限を意識しろ。

### 暫くの間のinstall.sh代わり
いろいろインストール
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" #homebrewのインストール
brew install fish
brew install tmux
brew install 
```
codeの設定
```
cd /Users/{ユーザー名}/Library/Application\ Support/Code/User
ln -s ~/dotfiles/vscode/keybindings.json
ln -s ~/dotfiles/vscode/settings.json
```

fishの設定
```
cd ~/.config/
mv fish/ fish.bak/
ln -s ~/dotfiles/fish
cp fish.bak/fishd.* ~/dotfiles/fish/ #既存の設定の継承
```
tmux
インストールなら
```
brew install tmux
```
設定の適応
```
cd
ln -s ~/dotfiles/.tmux.conf
```

vim
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -s ~/dotfiles/.vimrc
vim hoge.txt
```
vimのなかで
```
:PlugInstall
```

