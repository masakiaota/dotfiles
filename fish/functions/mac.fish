

set -x PATH /usr/local/bin /usr/local/sbin $PATH
set -x PATH ~/.local/bin $PATH #online-judge-tools用
set -x PATH ~/.nodebrew/current/bin:$PATH

#本当はintaractiveモードのときだけ実行するというふうに書いたほうがいいのだろうが。
set -x PYENV_ROOT $HOME/.pyenv

# なぜかMBAにはbinがないのに動く(エラーがうざいので空でmkdirした)
set -x PATH $PYENV_ROOT/bin $PATH
. (pyenv init - | psub);
. (pyenv virtualenv-init - | psub);
echo 'your python env is'
pyenv versions;

#alias
## rmでゴミ箱に入れる
## brew install rmtrash
alias rmt='rmtrash'

# AtCoder用
# alias ojd='rmtrash test/; oj d'

function mkcode
    for arg in $argv
        mkdir $arg; and\
        touch $arg/$arg.py
    end
end

function ojt
    oj t -c "python $argv"; and\
    echo 'あってるっぽい！'
end

function sub_by_pypy
    oj t -c "python $argv"; and\
    oj s -l 3510 -y -w 0 $argv 
end

function sub_pypy
    oj t -c "python $argv"; and\
    oj s -l 4047 -y -w 0 $argv 
end

function sub_by_python
    oj t -c "python $argv"; and\
    oj s -l 3023 -y -w 0 $argv 
end

#現在のdirをfinderで開く
alias finder="open ."

# 日本語を含むdir名とか深い階層へのアクセスが面倒なので
set drive ~/Documents/OneDrive


# kaggle kernel docker
alias ipy_kaggle='docker run -v $PWD:/tmp/working -w=/tmp/working --rm -it masakiaota/python_from_kaggle ipython'

function lab_kaggle --description "you can specify port by argument"
    if test $argv[1]
        docker run --shm-size=2048m -v $PWD:/tmp/working -w=/tmp/working -p $argv[1]:8888 --rm -it masakiaota/python_from_kaggle  jupyter lab --no-browser --ip="0.0.0.0" --notebook-dir=/tmp/working --allow-root
    else
        docker run --shm-size=2048m -v $PWD:/tmp/working -w=/tmp/working -p 8888:8888 --rm -it masakiaota/python_from_kaggle  jupyter lab --no-browser --ip="0.0.0.0" --notebook-dir=/tmp/working --allow-root
    end
end

function strun_kaggle --description "you should specify port by argument ex)strun_kaggle 7777 hello.py"
    docker run --shm-size=2048m -v $PWD:/tmp/working -w=/tmp/working -p $argv[1]:8501 --rm -it masakiaota/python_from_kaggle streamlit run $argv[2]
end

