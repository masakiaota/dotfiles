# エイリアスやシェル関数を定義するためのもの
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:
export LANG=ja_JP.UTF-8

#プロンプトの見た目を見やすくする
PS1="\n[\u@\h]
\W
\$ "


#pyenv
echo "starting pyenv"
export PYENV_ROOT="$HOME/.pyenv"
if [ -d ${PYENV_ROOT} ]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  if [ -d ${PYENV_ROOT}/plugins/pyenv-virtualenv ]; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# for bash_completion
if [ -f `brew --prefix`/etc/bash_completion ]; then
  source `brew --prefix`/etc/bash_completion
fi

echo "starting fish"
if ! fish; then
    "fish is not installed. starting xonsh"
    xonsh
fi
#echo "starting xonsh..."
#xonsh