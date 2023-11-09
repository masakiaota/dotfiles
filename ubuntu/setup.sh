# fish install
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install fish # apt -y upgradeがかかってるのでしばらくは使えない

# gitの設定
git config --global user.email "aotamasakimail@gmail.com"
git config --global user.name "masakiaota"

# VScodeの環境設定
mkdir ~/.vscode
echo '{
    "recommendations": [
        "ms-python.python",
        "ms-toolsai.jupyter",
        "GitHub.copilot"
    ]
}' > ~/.vscode/extensions.json

# tmuxの設定
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "
# tmuxの設定
# プレフィックスキー
unbind C-b
set-option -g prefix C-g

#set -g prefix C-g
bind-key g send-prefix


#https://qiita.com/nl0_blu/items/9d207a70ccc8467f7bab
#起動時にfishにする
# set-option -g default-shell /usr/local/bin/fish
set-option -g default-shell /usr/bin/fish

# tmuxを256色表示できるようにする
set-option -g default-terminal screen-256color
set -g terminal-overrides 'xterm:colors=256'

# ステータスバーをトップに配置する
set-option -g status-position top

# Wi-Fi、バッテリー残量、現在時刻
# 最右に表示
# set-option -g status-right '[%m-%d(%a) %H:%M]'
set -g status-right '#H'
# ステータスバーを1秒毎に描画し直す
set-option -g status-interval 1

# センタライズ（主にウィンドウ番号など）
set-option -g status-justify centre

# 番号基準値を変更
set-option -g base-index 1

# マウス操作を有効にする
set-option -g mouse on
bind -n WheelUpPane if-shell -F -t = \"#{mouse_any_flag}\" \"send-keys -M\" \"if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e'\"

# コピーモードを設定する
# コピーモードでvimキーバインドを使う
setw -g mode-keys vi

# 'v' で選択を始める
bind -T copy-mode-vi v send -X begin-selection

# 'V' で行選択
bind -T copy-mode-vi V send -X select-line

# 'C-v' で矩形選択
bind -T copy-mode-vi C-v send -X rectangle-toggle

# 'y' でヤンク
bind -T copy-mode-vi y send -X copy-selection

# 'Y' で行ヤンク
bind -T copy-mode-vi Y send -X copy-line

# 'C-p'でペースト
bind-key C-p paste-buffer

# #クリップボードにもコピー
# # 使うには brew install reattach-to-user-namespaceが必要
# bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel \"reattach-to-user-namespace pbcopy\"
bind-key -T copy-mode-vi Enter send -X copy-pipe-and-cancel \"reattach-to-user-namespace pbcopy\"

# tmpによる拡張機能管理
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-yank'
#激便利 https://github.com/tmux-plugins/tmux-resurrect
#激便利を更に15分ごとにやってくれるやつ https://github.com/tmux-plugins/tmux-continuum
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-pain-control'


# Other examples:
# set -g @plugin 'tmux-plugins/tmux-battery'
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'git@github.com/user/plugin'
# set -g @plugin 'git@bitbucket.com/user/plugin'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'

set -g @continuum-restore 'on'
" > ~/.tmux.conf

# 拡張機能(tpm)を有効化するためにあとで prefix + I するのを忘れずに

# cuda-driversのinstall #bashで実行
# https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html
sudo apt-get install linux-headers-$(uname -r)
distribution=$(. /etc/os-release;echo $ID$VERSION_ID | sed -e 's/\.//g')
wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda-drivers



# pyenv
sudo apt -y install git gcc make openssl libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev libffi-dev zlib1g-dev
curl https://pyenv.run | bash
# パスなどはpyenvのgithubを見て通そう。shellによってやり方が違うぞ https://github.com/pyenv/pyenv


# githubへの接続
sudo apt install gh
BROWSER=false gh auth login




