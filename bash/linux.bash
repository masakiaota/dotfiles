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

echo "pyenv activate anaconda3-4.3.1 for ubuntu"
pyenv activate anaconda3-4.3.1
