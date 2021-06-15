#!/usr/bin/bash
REPO_URL="https://github.com/fluoroom/papirus-folders-cycle"
clear
function bold () {
    echo "$(tput bold)${1}$(tput sgr0)"
}
#check if root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
function checkFiles () {
    if ([[ -f ps-folders-cycle.sh ]]&&[[ -f ps-folders-cycle.desktop ]]&&[[ -f ps-fc-cli.sh ]]&&[[ -f .ps-folders-cycle.example ]]); then
    echo true;
    else
    echo false;
    fi
}
if checkFiles; then
  echo "$(bold "Missing files"), please download repo again from $(bold $REPO_URL) ." && exit;

USER_HOME=$(eval echo ~${SUDO_USER})
echo " 
   $(tput smso)                                    $(tput rmso)
   $(tput smso) $(tput rmso) I'll help you installing: $(tput smso)        $(tput rmso)
   $(tput smso)                                    $(tput rmso)
   $(tput smso)  $(tput bold)Papirus Folder Cycle$(tput sgr0)$(tput smso) by $(tput bold)fluoroom$(tput sgr0)$(tput smso)  $(tput rmso)
   $(tput smso)                                    $(tput rmso)
   $(tput smso) $(tput rmso) https://github.com/fluoroom $(tput smso)      $(tput rmso)
   $(tput smso)                                    $(tput rmso)

Now I'll copy the files:
 .ps-folders-cycle.example ->  ${USER_HOME}/.ps-folders-cycle
 ps-folders-cycle.desktop  ->  ${USER_HOME}/.config/autostart/ps-folders-cycle.desktop
 ps-folders-cycle.sh       ->  ${USER_HOME}/bin/ps-folders-cycle.sh

Then I must grant execution permissions.
"

function install () {
    if [[ -f $USER_HOME/.ps-folders-cycle ]]; then
        echo "Found $(tput bold)${USER_HOME}/.ps-folders-cycle$(tput sgr0)"
        read -p "Do you want to keep your previous config file? (y/n)" choice
        case "$choice" in
        n|N ) cp .ps-folders-cycle.example $USER_HOME/.ps-folders-cycle && echo ".ps-folders-cycle.example ->  ${USER_HOME}/.ps-folders-cycle $(tput bold)config file replaced$(tput sgr0)";;
        *   ) echo "$(tput bold)Config file kept.$(tput sgr0)";;
        esac
    else
        cp .ps-folders-cycle.example $USER_HOME/.ps-folders-cycle && echo ".ps-folders-cycle.example ->  ${USER_HOME}/.ps-folders-cycle $(tput bold)OK$(tput sgr0)"
    fi
    cp ps-folders-cycle.desktop $USER_HOME/.local/share/applications/ps-folders-cycle.desktop && echo "ps-folders-cycle.desktop  ->  ${USER_HOME}/.local/share/applications/ps-folders-cycle.desktop $(tput bold)OK$(tput sgr0)"
    echo "${USER_HOME}/bin/ps-folders-cycle.sh" >> $USER_HOME/.local/share/applications/ps-folders-cycle.desktop && echo "${USER_HOME}/.local/share/applications/ps-folders-cycle.desktop $(tput bold)correctly configured.$(tput sgr0)"
    if [[ ! -d $USER_HOME/bin/ ]]; then
    mkdir $USER_HOME/bin/ && echo "Created ${USER_HOME}/bin/"
    fi
    cp ps-folders-cycle.sh $USER_HOME/bin/ps-folders-cycle.sh && echo "ps-folders-cycle.sh       ->  ${USER_HOME}/bin/ps-folders-cycle.sh $(tput bold)OK$(tput sgr0)"
    chmod +x $USER_HOME/bin/ps-folders-cycle.sh && echo "chmod +x ${USER_HOME}/bin/ps-folders-cycle.sh $(tput bold)OK$(tput sgr0)"
    cp ps-fc-cli.sh /usr/local/bin/ps-fc-cli && echo "$(tpud bold)CLI installed succesfully$(tput sgr0)"
    read -p "Enable now? (y/n)" choice
    case "$choice" in
    y|Y ) cp  $USER_HOME/.local/share/applications/ps-folders-cycle.desktop $USER_HOME/.config/autostart/ps-folders-cycle.desktop && echo "Autostart enabled $(bold OK)";
    gtk-launch ps-folders-cycle && echo "$(tput bold)Started$(tput sgr0)
To disable use $(tput bold)ps-fc-cli disable$(tput sgr0)";;
    * ) echo "
To enable use $(tput bold)ps-fc-cli enable$(tput sgr0)
";;
    esac
    
}

function bye (){
    echo "
Config file is $(tput bold)${USER_HOME}/.ps-folders-cycle$(tput sgr0)
Run $(tput bold)ps-fc-cli help$(tput sgr0) to see available commands.
"
exit
}

read -p "Shall i continue (y/n)?" choice
case "$choice" in 
  y|Y ) install && bye;;
  *   ) echo "Ok, marry to a single color then!" && exit;;
esac

