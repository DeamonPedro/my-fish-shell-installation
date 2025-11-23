set divider ""
set default_folder_style "*: :#b68f2f"
set shorten_path_from 2
set folder_styles "/: :#b68f2f" \
    "$HOME: :#b99d31" \
    "/etc*:漣:#b68f2f" \
    "/root*: :#b68f2f" \
    "$HOME/.config*:襁:#b68f2f" \
    "$HOME/Downloads*: :#b68f2f" \
    "$HOME/Pictures*: :#b68f2f" \
    "$HOME/Desktop*: :#b68f2f" \
    "$HOME/Music*:ﱘ :#b68f2f" \
    "$HOME/Videos*: :#b68f2f" \
    "$HOME/Documents*: :#b68f2f" \
    "$HOME/Backup*: :#b68f2f" \
    "$HOME/Share*: :#b68f2f" \
    "/media/*/Windows*: :#b68f2f" \
    "/sys*: :#b68f2f" \
    "/media*: :#b68f2f"

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
    if test (git rev-parse --is-inside-work-tree 2>/dev/null)
        if test -e (git rev-parse --show-toplevel)/.git/FETCH_HEAD
            set head_file (git rev-parse --show-toplevel)/.git/FETCH_HEAD
        else
            set head_file (git rev-parse --show-toplevel)/.git/HEAD
        end

        set last_fetch_time (stat -c %Y $head_file 2>/dev/null)
        if test -n "$last_fetch_time"
            if test (date -d 'now - 5 seconds' +%s) -ge $last_fetch_time
                git fetch --quiet 2>/dev/null
            end
        end

        set upstream (git rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2>/dev/null)

        if test -n "$upstream"
            set -g github (git rev-list --count "HEAD..$upstream" 2>/dev/null)
            set -g git (git rev-list --count "$upstream..HEAD" 2>/dev/null)
        else
            set -g github 0
            set -g git 0
        end

        set -g unmerged_files (git ls-files -u 2>/dev/null | wc -l)
        set -q github; or set github 0
        set -q git; or set git 0
        set -q unmerged_files; or set unmerged_files 0

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

alias autoremove "pacman -Rns $(pacman -Qdtq)"
alias clear "tput reset"
abbr install "sudo pacman -Syu"
abbr remove "sudo pacman -Rns"
abbr mi micro
abbr py python3
alias ls='logo-ls'
