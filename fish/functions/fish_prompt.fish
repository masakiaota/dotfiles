#/Users/{ユーザー名}/.config/fish/functions
function fish_prompt --description 'Write out the prompt'
	set -l last_status $status
    
    #改行
    echo
    # User
    set_color $fish_color_user
    echo -n (whoami)
    set_color normal

    echo -n '@'

    # Host
    set_color $fish_color_host
    echo -n (prompt_hostname)
    set_color normal

    echo -n ':  '
    __terlar_git_prompt
    __fish_hg_prompt

    # new line
    echo

    # PWD
    set_color $fish_color_cwd
    #echo -n (prompt_pwd)
    set -g fish_prompt_pwd_dir_length 6
    echo -n (prompt_pwd)
    set_color normal

    

    echo

    if not test $last_status -eq 0
        set_color $fish_color_error
    end

    echo -n '➤ '
    set_color normal

end

#gitのbranch名出す
# function git_branch
#     git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
# end

#右prompt
function fish_right_prompt
    echo -n (date "+%H:%M:%S")
    # echo (git_branch)
end

