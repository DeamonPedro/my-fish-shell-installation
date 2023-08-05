set divider ""
set default_folder_style "*: :#007766"
set shorten_path_from 2
set folder_styles "/: :#007766" \
    "$HOME: :#00875F" \
    "/etc*:漣:#007766" \
    "/root*: :#007766" \
    "$HOME/.config*:襁:#007766" \
    "$HOME/Downloads*: :#007766" \
    "$HOME/Pictures*: :#007766" \
    "$HOME/Desktop*: :#007766" \
    "$HOME/Music*:ﱘ :#007766" \
    "$HOME/Videos*: :#007766" \
    "$HOME/Documents*: :#007766" \
    "$HOME/Backup*: :#007766" \
    "$HOME/Share*: :#007766" \
    "/media/*/Windows*: :#007766" \
    "/sys*: :#007766" \
    "/media*: :#007766"

function fish_prompt
    set_color brwhite --background "#121212"
    echo -n "  "
    set -a folder_styles $default_folder_style
    for style in $folder_styles
        set style_folder (string split -n ':' $style)
        if test (string match $style_folder[1] (pwd))
            set current_dir_icon $style_folder[2]
            set current_dir_color $style_folder[3]
            break
        end
    end
    set dir (pwd | sed "s|^$HOME|~|g")
    set dirs (string split -n '/' $dir)
    if test (count $dirs) -gt $shorten_path_from
        set dir ""
        for index in (seq $shorten_path_from)
            set dir "/"$dirs[(math -$index)]$dir
        end
        set dir (test $dirs[(math -$shorten_path_from-1)] = "~"; and echo "~"; or echo "…")$dir
    end
    set_color "#121212" --background "$current_dir_color"
    echo -n "$divider"
    set_color "#000000" --background "$current_dir_color"
    echo -n " $current_dir_icon$dir "
    set_color "$current_dir_color" --background normal
    echo -n "$divider"
    set_color normal
end

function fish_title
    string match -r "[^/]*\$" $PWD
end

function fish_right_prompt -d "Write out the right prompt"
    if test (git status 2> /dev/null | wc -l) -gt 0
        __git_info
    end
end

function __git_sync_info
    if test (git status 2> /dev/null | wc -l) -gt 0
        set last_fetch_time (stat -c %Y (git rev-parse --show-toplevel)/.git/FETCH_HEAD)
        if test (date -d 'now - 5 seconds' +%s) -ge $last_fetch_time
            git fetch --quiet 2>/dev/null
        end
        set -g remote (git remote)
        set -g github (git rev-list --count "HEAD..@{upstream}")
        set -g git (git rev-list --count "@{upstream}..HEAD")
        set -g unmerged_files (git ls-files -u | wc -l)
        if test $unmerged_files -gt 0
            set_color "#E91D14"
            echo -n " "
        end
        if test $github -gt 0
            set_color "#FF8C00"
            echo -n " "
        end
        if test $git -gt 0
            set_color "#FFD700"
            echo -n " "
        end
        if test $github -eq 0 -a $git -eq 0 -a $unmerged_files -eq 0
            set_color "#32CD32"
            echo -n " "
        end
    end
end

function __git_info
    if test (git status 2> /dev/null | wc -l) -gt 0
        set -g branch (git symbolic-ref --short HEAD 2>/dev/null; or command git show-ref --head -s --abbrev | head -n1 2>/dev/null)
        set -g untracked_files (git ls-files . --exclude-standard -m -o)
        set -g remote (git remote)
        if test "$remote"
            set icon " "
        else
            set icon " "
        end
        set_color "#007766"
        echo -n "$icon $branch "
        if test "$untracked_files"
            set_color "#20b2aa"
            echo -n " "
        end
        echo -n "$(__git_sync_info) "
        set_color normal
    end
end

function fish_user_key_bindings
    bind \cl 'command clear; fish_prompt'
    bind \cq 'commandline ""'
end

function __git_sync_info_loading_indicator -a last_prompt
    echo -n "$last_prompt" | sed -r 's/\x1B\[[0-9;]*[JKmsu]//g' | read -zl uncolored_last_prompt
    echo -n (set_color "#878787")"$uncolored_last_prompt"(set_color normal)
end

alias update "sudo apt update"
alias upgrade "sudo apt upgrade"
alias autoremove "sudo apt autoremove"
alias clear "tput reset"
abbr install "sudo apt install"
abbr remove "sudo apt remove"
abbr mi micro
abbr py python3
alias ls='logo-ls'
