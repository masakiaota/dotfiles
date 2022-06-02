### 戒め
* 環境構築に必要以上に時間をかけるのは時間の無駄。
* 自分の把握しきれない設定は存在しないも同じ。
* 必要最低限を意識しろ。

### WIP
- [ ] ディレクトリ構造の見直し
- [x] shell scriptのなかでDarwinとLinuxで分離するようにしよう
- [ ] link.shのメンテ(ln -sは一つのファイルでいい)分けるとかえって面倒
- [ ] install.shとlink.shはソフトごとに別々にファイルを書いてそれを読み込む用にしよう(xcode周りが入ってないと一発じゃ入れられないので)

### 使っているもの
- written in .brewfile

### 手順
環境はmacを想定している

```
cd 
git clone https://github.com/masakiaota/dotfiles.git
cd ./dotfiles/
#sh install.sh
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

### Python環境
重いがなんやかんやpyenvで使うものごと切り替えるのが便利。
anacondaを入れるとpipする手間が省けたりして楽。(しかも実行速度も早いらしい？)

### shell環境
bashからfishを呼び出してる

### Macの環境
```
# カーソルの高速化
defaults write -g InitialKeyRepeat -int 18
defaults write -g KeyRepeat -float 1.2
```

### docker
```
docker build -t masakiaota/python_from_kaggle .
docker build -t masakiaota/jupyter_datascience .
```


### ディレクトリの説明
- bash
  - .bashrc ... 本体
  - mac.bash ... mac用の設定
- fish ... 本来.config以下にある
  - functions ... こいつごとlinkしてる
  - config.fish ... 本体
- karabiner ... 本来.config以下にある
  - オレオレキーバインドが設定できる
- vscode
- .gitignore ... あんま使ってなくてそもそもリンクさせてない…
- .hyper.js
- .tmux.conf
- .vimrc
- .xonshrc ... fishがないサーバーではxonshを使う
- snippets.xml ... Clipyのsnippetsだがいまいち管理できてない