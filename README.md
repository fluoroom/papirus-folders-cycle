# papirus-folders-cycle
Changes Papirus folder colors every X seconds. With selective colors and shuffle.

![gif](https://i.imgur.com/tgKTgNe.gif) <sup><sup><sup><sup>(speed only for illustrative purposes)</sup></sup></sup></sup>

This program is based on and **requires** previous installation of the great [papirus-folders](https://github.com/PapirusDevelopmentTeam/papirus-folders).
## Installation
Clone this **entire** project, enter its folder and run `install.sh`:
<pre><code>$ git clone https://github.com/fluoroom/papirus-folders-cycle.git
$ cd papirus-folders-cycle
$ ./install.sh</code></pre>
## Usage
Once installed, the CLI is available:
<pre><code>$ ps-fc-cli help
Papirus Folders Cycle CLI (<b>ps-fc-cli</b>) has this available commands:
<b>help / --help / -h</b>   Show this help.
<b>enable</b>               Enables cycling (from next log on).
<b>disable</b>              Stops cycling and removes autostart on log on.
<b>uninstall</b>            Uninstalls Papirus Folders Cycle and CLI is self-destroyed forever.
<b>Error 404:</b>           This happens when i don't find the icon theme's folder in <b>~/.icons/</b>, please install icons there as i can't (and <b>shouldn't</b>) have root access to read <b>/usr/share/icons/</b>.</code></pre>
Edit your config file (**~/.ps-folders-cycle**), here's an example:
<pre><code>#!/usr/bin/bash
changeEvery=300;     # seconds | program won't accept less than 10,
                     # and recommended is 60 or higher
theme=Papirus        # change if you're using Papirus-Dark or other icon theme.
                     # Use quotes ("") if name has spaces.
shuffleCycle=false   # (true | false) activate random order
shuffleStart=true    # (true | false) start from random color,
                     # continue in order (if not shuffling).
startupNotif=true    # (true | false) notify that program was started
colorNotif=true      # (true | false) notify when color changed

#Enter colors separated by spaces or new lines.
#Arrange in desired order of cycling.
#Check available colors on https://github.com/PapirusDevelopmentTeam/papirus-folders

colors=(black bluegrey brown cyan green indigo nordic
palebrown pinkteal white yellow blue breeze carmine
deeporange grey magenta orange paleorange red violet yaru)</code></pre>
