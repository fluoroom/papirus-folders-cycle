#!/usr/bin/bash
# set defaults
allColors=(black bluegrey brown cyan green indigo nordic palebrown pink teal white yellow blue breeze carmine deeporange grey magenta orange paleorange red violet yaru)
colors=$allColors
theme=Papirus
changeEvery=3600 #seconds
shuffleCycle=false
startupNotif=false
colorNotif=false
shuffleStart=true

#read config file
USER_HOME=$(eval echo ~${SUDO_USER})
APPS_DIR=/usr/share/applications
CONFIG=$USER_HOME/.ps-folders-cycle
if [[ -f "$CONFIG" ]]; then
    . $CONFIG
    echo "
Loaded config file ($CONFIG):"
else 
    echo "
Config file ($CONFIG) not found. Using default configuration:"
fi

#set variables from defaults or config

interval=$changeEvery
shuffle=$shuffleCycle
echo "Colors (in order): ${colors[@]}
Theme: $theme
Interval: $interval seconds
Shuffle: $shuffle
Shuffle start: $startupNotif
Startup notification: $startupNotif
Color change notification: $colorNotif
"

if [ $interval -lt 10 ]; then
    echo "You set an interval of $interval seconds? No way that's stable! We'll use 10 seconds. Ideal is 60 seconds or higher.
    "
    interval=10
fi
colorsLength=${#colors[@]}
actualIndex=0

function notifyStartup () {
    notify-send "papirus-folders-cycle started!"
}
function notifyColor () {
    notify-send "Folder color changed to ${1}"
}
function getRandomUpTo () {
    echo "RANDOM % ${1}"
}


if $shuffleStart; then actualIndex= getRandomUpTo $colorsLength; fi

function daemon (){
while :; do   {
    if [ ${actualIndex} -ge $colorsLength ]; then
        actualIndex=0
    elif $shuffle; then
        let shuffleIndex=getRandomUpTo $colorsLength;
        while [ $actualIndex -eq $shuffleIndex ];
        do
            let shuffleIndex=getRandomUpTo $colorsLength;
        done
        actualIndex=$shuffleIndex
    fi 
    papirus-folders -t $theme -C ${colors[actualIndex]}
    if $colorNotif; then notifyColor ${colors[actualIndex]}; fi
    if [ $shuffle == false ];  then
        actualIndex=$((actualIndex+1))
    fi 
    sleep $interval;
}
done
}
if $startupNotif; then notifyStartup; fi
daemon
exit 0