### 戒め
* 環境構築に必要以上に時間をかけるのは時間の無駄。
* 自分の把握しきれない設定は存在しないも同じ。
* 必要最低限を意識しろ。

### 暫くの間のinstall.sh代わり
codeの設定
```
cd /Users/{ユーザー名}/Library/Application\ Support/Code/User
ln -s ~/dotfiles/vscode/keybindings.json
ln -s ~/dotfiles/vscode/settings.json
```

fishの設定(fish/にあるlink.shで実行可能)
```
cd ~/.config/
mv fish/ fish.bak/
ln -s ~/dotfiles/fish
```

vim
```
ln -s ~/dotfiles/.vimrc
```

