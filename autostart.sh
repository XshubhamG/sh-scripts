#!/usr/bin/env bash

# Script name: autostart
# Description: Add and remove programs to autostart directory.
# Dependencies: fzf
# GitLab: https://www.gitlab.com/dwt1/fzscripts
# License: https://www.gitlab.com/dwt1/fzscripts
# Contributors: Derek Taylor

# Set with the flags "-e", "-u","-o pipefail" cause the script to fail
# if certain things happen, which is a good thing.  Otherwise, we can
# get hidden bugs that are hard to discover.
set -euo pipefail

# The FMENU variable contains the 'fzf' command with our settings.
# Note that the last setting is 'prompt' which is left empty.
# You add the prompt when you invoke $FMENU. For example: $FMENU "my prompt"
FMENU="fzf --header=$(basename "$0") \
           --layout=reverse \
           --exact \
           --border=bold \
           --border=rounded \
           --margin=3% \
           --multi \
           --height=95% \
           --info=hidden \
           --header-first \
           --bind change:top \
           --prompt"

autostart_files=()
for dir in $HOME/.config/autostart/; do
    if [ -d "$dir" ]; then
        # Using -printf "%f\n" to get filenames without full path.
        autostart_files+=("$(find "$dir" -type f -printf "%f\n")")
    fi
done

desktop_files=()
dirs=$(echo "$XDG_DATA_DIRS" | sed 's/:/\/applications /g')
for dir in ${dirs}; do
    if [ -d "$dir" ]; then
        # The -print is the default for 'find' so not needed.
        # The -print contains the full path which is needed for later.
        desktop_files+=("$(find "$dir" -type f -print)")
    fi
done

# Lists all files within the autostart directory.
listauto() {
    tput setaf 6 bold
    printf "%s\n" "Programs currently in autostart directory:"
    tput sgr0
    tree ~/.config/autostart/ | grep -e '├' -e '└' --color=never
}

# Lists the desktop files allowing user to add selections to autostart directory.
addauto() {
    if [ ! -d "$HOME"/.config/autostart ]; then
        mkdir -p "$HOME"/.config/autostart || echo "$HOME/.config/autostart does not exist."
    fi

    selected_file=$($FMENU "Add program to autostart: " < <(printf "%s\n" "${desktop_files[@]}"))
    if [[ -n "$selected_file" ]]; then
        selected_array=$selected_file
        for i in "${selected_array[@]}"; do
            tput setaf 5 bold
            printf "%s" "✓ "
            tput setaf 5 bold
            cp "$i" ~/.config/autostart/
            printf "%s" "$(basename "$i")"
            tput sgr0
            printf "%s\n\n" " added to autostart directory."
        done
    else
        echo "No options selected."
    fi
}

# Lists all files within the autostart directory allowing user to remove selections.
rmauto() {
    selected_file=$($FMENU "Remove program from autostart: " < <(printf "%s\n" "${autostart_files[@]}"))

    if [[ -n "$selected_file" ]]; then
        selected_array=$selected_file
        for i in "${selected_array[@]}"; do
            tput setaf 9 bold
            printf "%s" "✗ "
            tput setaf 9 bold
            rm ~/.config/autostart/"$i"
            printf "%s" "$(basename "$i")"
            tput sgr0
            printf "%s\n\n" " removed from autostart directory."
        done
    else
        echo "No options selected."
    fi
}

while getopts "alrh" arg 2>/dev/null; do
    case "${arg}" in
        a)
            addauto
            listauto
            exit
            ;;
        l)
            listauto
            exit
            ;;
        r)
            rmauto
            listauto
            exit
            ;;
        h)
            printf "Usage: auto [options]
Description: Add/remove programs for autostart.
Dependencies: fzf
Note: Make a single selection by pressing ENTER or multiple selections by pressing SHIFT+TAB.

The folowing OPTIONS are accepted:
    -h  displays this help page
    -a  add programs to autostart directory
    -l  list contents of autostart directory
    -r  remove programs from autostart directory

Running startup without any arguments will prompt you to choose an option.
It will then rerun the script with the correct option.
            Run 'man auto' for more information\n"
            exit
            ;;
        *)
            printf '%s\n' "Error: invalid option" "Type '$(basename "$0") -h' for help" ;;
    esac
    no_opt=0
done

if [ $# -eq 0 ]; then
    options=("Add a program to autostart" "Remove a program from autostart" "List contents of autostart directory" "Get help information about this program" "Quit")
    menu=$($FMENU "What do you want to do? " < <(printf "%s\n" "${options[@]}"))
    selection=$menu
    case $selection in
        "Add a program to autostart")
            $0 -a
            exit
            ;;
        "Remove a program from autostart")
            $0 -r
            exit
            ;;
        "List contents of autostart directory")
            $0 -l
            exit
            ;;
        "Get help information about this program")
            $0 -h
            exit
            ;;
        "Quit")
            exit
            ;;
    esac
fi
