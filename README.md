### 戒め
* 環境構築に必要以上に時間をかけるのは時間の無駄。
* 自分の把握しきれない設定は存在しないも同じ。
* 必要最低限を意識しろ。


### 使っているもの
- written in .Brewfile

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
pyenvを入れてるがuv推奨

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