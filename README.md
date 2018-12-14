### 戒め
* 環境構築に必要以上に時間をかけるのは時間の無駄。
* 自分の把握しきれない設定は存在しないも同じ。
* 必要最低限を意識しろ。

### WIP
大幅改築中

### 手順
- [ ] shell script or xonsh scriptのなかでDarwinとLinuxで分離するようにしよう
環境はmacを想定している

- [ ] install.shとlink.shはソフトごとに別々にファイルを書いてそれを読み込む用にしよう(xcode周りが入ってないと一発じゃ入れられないので)

```
cd 
git clone https://github.com/masakiaota/dotfiles.git
cd ./dotfiles/
sh install.sh
sh link.sh
```
最後の仕上げに行く

### 最後の仕上げ

#### vim
vimのなかで
```
:PlugInstall
```

#### tmux
tmuxの中で
prefix(ctrl g)＋I(shift i)

updateには
prefix(ctrl g)＋U(shift u)

詳しい操作は 
https://github.com/tmux-plugins/tpm
