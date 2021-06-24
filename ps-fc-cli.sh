#!/bin/bash
#check if root
function bold () {
    echo "$(tput bold)${1}$(tput sgr0)"
}

if [[ "$EUID" -ne 0 && $1 != "help" ]];
  then echo "Please run as root"
  exit
fi
USER_HOME=$(eval echo ~${SUDO_USER})
APPS_DIR=/usr/share/applications
function checkInstalled () {
    if ([[ -f $USER_HOME/bin/ps-folders-cycle.sh ]]&&[[ -f $APPS_DIR/ps-folders-cycle.desktop ]]&&[[ -f /usr/local/bin/ps-fc-cli ]]); then
    return 1;
    else
    return 0;
    fi
}
if [[ ! -f $USER_HOME/.ps-folders-cycle ]]; then
    echo "$(bold "Config file not found, reinstall to regenerate.")
    ";
fi
function disable () {
    if killall ps-folders-cycle.sh; then echo "Process succesfully killed"; else echo "Process was $(bold not) running"; fi
    rm  $USER_HOME/.config/autostart/ps-folders-cycle.desktop && echo "Removed autostart";
    if checkInstalled == 0; then
    echo "Missing files, please reinstall."
    fi
    echo "$(bold Disabled)" && exit;
}

function enable () {
    if checkInstalled==1; then
    cp $APPS_DIR/ps-folders-cycle.desktop $USER_HOME/.config/autostart/ps-folders-cycle.desktop && echo "$(bold "Enabled!") I'll start cycling on next log on.";
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
 ${APPS_DIR}/ps-folders-cycle.desktop
 ${USER_HOME}/.config/autostart/ps-folders-cycle.desktop
 ${USER_HOME}/bin/ps-folders-cycle.sh

This CLI will self-destroy.

Config file $(tput bold)${USER_HOME}/.ps-folders-cycle$(tput sgr0) will be left there for future use."

    read -p "Shall i continue (y/n)?" choice
    case "$choice" in 
    y|Y )
    killall ps-folders-cycle.sh && echo "Process succefully killed"
    rm $APPS_DIR/ps-folders-cycle.desktop && echo "${APPS_DIR}/ps-folders-cycle.desktop $(bold deleted)"
    rm $USER_HOME/.config/autostart/ps-folders-cycle.desktop && echo "{USER_HOME}/.config/autostart/ps-folders-cycle.desktop $(bold deleted)"
    rm $USER_HOME/bin/ps-folders-cycle.sh && echo "${USER_HOME}/bin/ps-folders-cycle.sh $(bold deleted)"
    rm /usr/local/bin/ps-fc-cli && echo "This CLI was self-destroyed.
Completely uninstalled."
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
$(bold "help / --help / -h")      Show this help.
$(bold enable)                  Enables cycling (from next log on).
$(bold disable)                 Stops cycling and removes autostart on log on.
$(bold uninstall)               Uninstalls Papirus Folders Cycle and CLI is self-destroyed forever.
$(bold "Error 404:")              This happens when i don't find the icon theme's folder in $(bold ~/.icons/), please install icons there as i can't have root access to read $(bold /usr/share/icons/)." && exit;
}

case "$1" in
    help|--help|-h ) help;;
    enable ) enable;;
    uninstall ) uninstall;;
    disable ) disable;;
    * ) echo "Command $(bold $1) is not valid, run $(bold "ps-fc-cli help") for help" && exit;;
esac
