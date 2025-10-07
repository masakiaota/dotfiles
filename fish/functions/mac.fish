

set -x PATH /usr/local/bin /usr/local/sbin $PATH
set -x PATH ~/.local/bin $PATH #online-judge-tools用
set -x PATH ~/.nodebrew/current/bin:$PATH


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

# function sub_by_pypy
#     oj t -c "python $argv"; and\
#     oj s -l 3510 -y -w 0 $argv 
# end

function sub_pypy
    oj t -c "python $argv"; and\
    oj s -l 4047 -y -w 0 $argv 
end

# function sub_by_python
#     oj t -c "python $argv"; and\
#     oj s -l 3023 -y -w 0 $argv 
# end

function run_cython
    set stem (string split ".pyx" "" $argv); and\
    cythonize -3 -i $argv > /dev/null ; and\
    python -c "import $stem"
end

#現在のdirをfinderで開く
alias finder="open ."

# 日本語を含むdir名とか深い階層へのアクセスが面倒なので
set drive ~/Documents/OneDrive

