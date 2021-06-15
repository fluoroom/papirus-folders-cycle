#!/bin/bash
#check if root
function bold () {
    echo "$(tput bold)${1}$(tput sgr0)"
}

if [[ "$EUID" -ne 0 && $1 != "help" ]]
  then echo "Please run as root"
  exit
fi
USER_HOME=$(eval echo ~${SUDO_USER})
function checkInstalled () {
    if ([[ -f $USER_HOME/bin/ps-folders-cycle.sh ]]&&[[ -f $USER_HOME/.local/share/applications/ps-folders-cycle.desktop ]]&&[[ -f /usr/local/bin/ps-fc-cli ]]); then
    echo true;
    else
    echo false;
    fi
}
if [[ ! -f $USER_HOME/.ps-folders-cycle ]]; then
    echo "$(bold "Config file not found, reinstall to regenerate.")
    ";
fi
function disable () {
    killall ps-folders-cycle.sh
    rm  $USER_HOME/.config/autostart/ps-folders-cycle.desktop
    if checkInstalled; then
        echo true;
    else
    echo "Missing files, please reinstall."
    fi
    echo "$(bold Disabled)" && exit;
}

function enableOnce () {
    if checkInstalled; then
    gtk-launch ps-folders-cycle && echo "$(bold "Started until log out")" && exit;
    else
    echo "Missing files, please reinstall." && exit;
    fi
}

function enable () {
    if checkInstalled; then
    cp  $USER_HOME/.local/share/applications/ps-folders-cycle.desktop $USER_HOME/.config/autostart/ps-folders-cycle.desktop && echo "Autostart enabled $(bold OK)";
    gtk-launch ps-folders-cycle && echo "$(bold Started)" && exit;
    else
    echo "Missing files, please reinstall." && exit;
    fi
}

function uninstall () {
    clear
    echo " 
   $(tput smso)                                    $(tput rmso)
   $(tput smso) $(tput rmso) I'll help you uninstalling: $(tput smso)      $(tput rmso)
   $(tput smso)                                    $(tput rmso)
   $(tput smso)  $(tput bold)Papirus Folder Cycle$(tput sgr0)$(tput smso) by $(tput bold)fluoroom$(tput sgr0)$(tput smso)  $(tput rmso)
   $(tput smso)                                    $(tput rmso)
   $(tput smso) $(tput rmso) https://github.com/fluoroom $(tput smso)      $(tput rmso)
   $(tput smso)                                    $(tput rmso)

Now I'll stop the program and delete the files:
 ${USER_HOME}/.local/share/applications/ps-folders-cycle.desktop
 ${USER_HOME}/.config/autostart/ps-folders-cycle.desktop
 ${USER_HOME}/bin/ps-folders-cycle.sh

This CLI will self-destroy.

Config file $(tput bold)$USER_HOME/.ps-folders-cycle$(tput sgr0) will be left there for future use."

    read -p "Shall i continue (y/n)?" choice
    case "$choice" in 
    y|Y )
    killall ps-folders-cycle && echo "Process succefully killed"
    rm $USER_HOME/.local/share/applications/ps-folders-cycle.desktop && echo "${USER_HOME}/.local/share/applications/ps-folders-cycle.desktop $(bold deleted)"
    rm $USER_HOME/.config/autostart/ps-folders-cycle.desktop && echo "{USER_HOME}/.config/autostart/ps-folders-cycle.desktop $(bold deleted)"
    rm $USER_HOME/bin/ps-folders-cycle.sh && echo "${USER_HOME}/bin/ps-folders-cycle.sh $(bold deleted)"
    rm /usr/local/bin/ps-fc-cli && echo "This CLI was self-destroyed. Completely uninstalled."
    echo "
    Bye!
    " && exit;;
    *   ) echo "
        Yay! $(bold "You're keeping me!")
    " && exit;;
    esac
}

function help () {
    echo "Papirus Folders Cycle CLI ($(bold ps-fc-cli)) has this available commands:
$(bold help)        Show this help.
$(bold enable)      Starts cycling forever.
$(bold enable-once) Starts cycling only until log out.
$(bold uninstall)   Uninstalls Papirus Folders Cycle and CLI is self-destroyed forever.
$(bold disable)     Stops cycling and removes autostart on log on."
exit;
}

case $1; in
    help ) help;;
    enable ) enable;;
    enable-once ) enableOnce;;
    uninstall ) uninstall;;
    disable ) disable;;
esac
