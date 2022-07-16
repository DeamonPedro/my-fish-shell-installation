set divider ""
set default_folder_style "*: :#007766"
set shorten_path_from 2
set folder_styles "/: :#007766"\
 "$HOME: :#00875F"\
 "/etc*:漣:#007766"\
 "/root*: :#007766"\
 "$HOME/.config*:襁:#007766"\
 "$HOME/Downloads*: :#007766"\
 "$HOME/Pictures*: :#007766"\
 "$HOME/Desktop*: :#007766"\
 "$HOME/Music*:ﱘ :#007766"\
 "$HOME/Videos*: :#007766"\
 "$HOME/Documents*: :#007766"\
 "$HOME/Backup*: :#007766"\
 "$HOME/Share*: :#007766"\
 "/media/*/Windows*: :#007766"\
 "/sys*: :#007766"\
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
        if test ! -n "$next_git_update"
            set -g next_git_update (date --date="5 seconds" +"%Y%m%d%H%M%S")
        end
        if test (date +"%Y%m%d%H%M%S") -ge $next_git_update
            echo (git fetch --quiet 2> /dev/null &) >/dev/null
            set -g next_git_update (date --date="5 seconds" +"%Y%m%d%H%M%S")
        end
        set -g branch (git symbolic-ref --short HEAD 2>/dev/null; or command git show-ref --head -s --abbrev | head -n1 2>/dev/null)
        set -g untracked_files (git ls-files . --exclude-standard -m -o)
        set -g remote (git remote)
        set -g revs (git rev-list --count --left-right "@{upstream}..HEAD" 2>/dev/null)
        set -g github (echo $revs | cut -f1)
        set -g git (echo $revs | cut -f2)
        if test "$revs"
            if test $github -gt 0 -a $git -gt 0
                set status_color "#E91D14"
                set info " "
            else if test $github -gt 0
                set status_color "#FF8C00"
                set info " "
            else if test $git -gt 0
                set status_color "#FFD700"
                set info " "
            else
                set status_color "#32CD32"
                set info " "
            end
        end

        if test (count $remote) -gt 0
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
        set_color $status_color
        echo -n "$info "
        set_color normal
    end
end

function fish_user_key_bindings
    bind \cl 'command clear; fish_prompt'
    bind \cq 'commandline ""'
end

alias update "sudo apt update"
alias upgrade "sudo apt upgrade"
abbr install "sudo apt install"
abbr remove "sudo apt remove"
alias autoremove "sudo apt autoremove"
alias clear "tput reset"
abbr mi "micro"
abbr py "python3"