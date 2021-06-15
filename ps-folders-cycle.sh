#!/usr/bin/bash
# set defaults
allColors=(black bluegrey brown cyan green indigo nordic palebrown pink teal white yellow blue breeze carmine deeporange grey magenta orange paleorange red violet yaru)
colors=$allColors
theme=Papirus
changeEvery=3600 #seconds
shuffleCycle=false

#read config file
CONFIG=~/.ps-folders-cycle
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
"

#infinite loop
if [ $interval -lt 10 ]; then
    echo "You set an interval of $interval seconds? No way that's stable! We'll use 10 seconds. Ideal is 60 seconds or higher.
    "
    interval=10
fi
colorsLength=${#colors[@]}
actualIndex=0
newTrue=true
function daemon (){
while :; do   {
    if [ ${actualIndex} -ge $colorsLength ]; then
        actualIndex=0
    elif $shuffle; then
        let shuffleIndex="RANDOM % colorsLength"
        while [ $actualIndex -eq $shuffleIndex ];
        do
            let shuffleIndex="RANDOM % colorsLength"
        done
        actualIndex=$shuffleIndex
    fi 
    papirus-folders -t $theme -C ${colors[actualIndex]} &
    if [ $shuffle == false ];  then
        actualIndex=$((actualIndex+1))
    fi 
    sleep $interval;
}
done
}
daemon
exit 0