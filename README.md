### 戒め
* 環境構築に必要以上に時間をかけるのは時間の無駄。
* 自分の把握しきれない設定は存在しないも同じ。
* 必要最低限を意識しろ。

### WIP
- [ ] 基本的にroot権限がなくてもインストールできるようにする
    - [ ] homebrew, linuxbrewはホームディレクトリにパスを通す
- [x] labの計算機のデフォルトのshellをbashに変更
- [x] bashでも使えるようにbashrcを持ってくる。
  - [x]どの計算機にも入っているbashを基本とする。
  - [x]fishが入っている場合にはbashからfishを起動
  - [x]fishが入っていない場合にはxonshの起動を試みる。
- [x] fish.configの見直し
  - [ ] hostがほしい(なんのことだっけ)
- [ ] itermの設定のバックアップ取れない？
- [ ] ディレクトリ構造の見直し
- [x] shell scriptのなかでDarwinとLinuxで分離するようにしよう
- [ ] link.shのメンテ(ln -sは一つのファイルでいい)分けるとかえって面倒
- [ ] install.shとlink.shはソフトごとに別々にファイルを書いてそれを読み込む用にしよう(xcode周りが入ってないと一発じゃ入れられないので)

### 使っているもの
- mac
  - tree
  - rmtrash
  - git(macにもともと入っているが脆弱性があるため最新版)
  - fish
  - htop
  - tmux
  - pyenv
  - wget
  - autossh(あんま使ってないけど)

- ubuntu
  - 管理者権限がないので基本的にありあわせ  

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
- [ ] tarballをコンパイルして、sudo なしでもinstallできるようにしたい


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