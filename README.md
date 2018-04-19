![logo](https://github.com/BxNxM/rpitools/blob/master/template/demo_images/rpitools_logic.png?raw=true)

```
  _____    _____    _____   _______    ____     ____    _         _____ 
 |  __ \  |  __ \  |_   _| |__   __|  / __ \   / __ \  | |       / ____|
 | |__) | | |__) |   | |      | |    | |  | | | |  | | | |      | (___  
 |  _  /  |  ___/    | |      | |    | |  | | | |  | | | |       \___ \ 
 | | \ \  | |       _| |_     | |    | |__| | | |__| | | |____   ____) |
 |_|  \_\ |_|      |_____|    |_|     \____/   \____/  |______| |_____/ 
```
## WHAT IS RPITOOLS [HomeCloud]?
* RPITOOLS is an installation and configuration (deployment) system for the raspberry pi (Zero, and 3). It deploys the official raspbain lite operating system and many useful programs, and set the complete system to a tiny playground and procreate your HomeCloud. 
* Completly set for remote usage - ssh, sshfs, sftp, smb, vnc(optional), website(http)
* Sets an optinal GUI (PIXEL) for graphical usage
* Supports a UNIQUE extension shiled with many periphery.
* LIST OF FUNCTIONS:
	* torrent client - transmission (with http client, port: 9091)
	* network drive - samba (smb)
	* OLED (128x64) display support on extension shield
	* extarnal ip deepnet clinet access (dropbox - external ip sync)
	* disks automount, and command line interface
	* git config
	* terminal/command line set for easy usage - aliases and so on
	* vim, xdotool, scrot, python (with many modules), kodi etc.
	* custom ```rpitools/autodeployment/config/rpitools_config.cfg``` user configuration based on ```rpitools/autodeployment/config/rpitools_config_template.cfg```
	* easy update: ```update_rpitools```
	* custom login help console:

```
WELCOME pi! PI IP ADDRESS 10.0.1.7 
Connected from: fe80::1421:2053:794e:fa25%wlan0
WELCOME pi! PI IP ADDRESS 10.0.1.7 
TODAY: Thu Apr 19 19:25:25 UTC 2018
     April 2018       
Su Mo Tu We Th Fr Sa  
 1  2  3  4  5  6  7  
 8  9 10 11 12 13 14  
15 16 17 18 19 20 21  
22 23 24 25 26 27 28  
29 30                 
                      
HOME DISK: 41M	./

AVAIBLE SERVICES AND TOOLS:
Service (rpitools) interfaces:
	oledinterface -h	-> oled service command line control
	rgbinterface -h		-> rgb command line control
	hapticinterface -h	-> vibre motor cmd line control
	sysmonitor -h		-> system monitoring tool
	diskhandler -h		-> external disks handling based on fstab
	confighandler -h	-> config handler based on rpitools_config.cfg
	mysshfs			-> built in sshfs based on rpitools_config.cfg
	update_rpitools		-> update your repository
Manage GUI (X):
	startxbg		-> start gui in the background
	pkill x 		-> stop gui
	startvnc		-> start vnc service
	kodibg			-> start kodi media center
Other commands:
	Add new user for
	apache webshared dir:	htpasswd -cb /home/pi/.secure/apasswords user_name user_pwd
	Add new samba user:	sudo smbpasswd -a samba_user

for more info use: ->| alias |<- command
########################################################
```

## How to install: 
####CONFIGURATION ON MAC

***Deploy and setup raspbian image***

* Download raspbian lite:

```
Browse:
https://www.raspberrypi.org/downloads/raspbian/

and dowload:
RASPBIAN STRETCH LITE
example: https://downloads.raspberrypi.org/raspbian_lite_latest
```
* open terminal ```CMD+SPACE``` type ```Terminal``` press enter

* clone rpitools repository from github - to get the resources

```
git clone https://github.com/BxNxM/rpitools.git
```

* go to rpitools/prepare/sd_card/ to find SD card preparing scripts

```
cd rpitools/prepare/sd_card/
```

* Create custom config file from template
 
```
Jump to the config folder:
pushd ../../autodeployment/config/

Copy template file:
cp rpitools_config_template.cfg rpitools_config.cfg

Edit your configuration:
open rpitools_config.cfg

WRITE YOUR CUSTOM PARAMETERS TO THE "<>" PLACEHOLDERS

EXAMPLE:
  6 [NETWORK]				; offlineset
  7 ssid="<>"				; your wifi name
  8 pwd="<>"				; your wifi password 
  .
  .
  .
  
Go back to the deployment scripts:
popd
```

* Execute deployment scripts:

```
./1_raspbian_imager.bash
###### DESCRIPTION ######
* It deploys (write) the factory raspbian_lite_latest image to the SD card.
(It serach your rapbian image from Downloads folder)
(If it not works copy your image under: rpitools/prepare/sd_card/raspbian_img)
#########################

./2_boot_config.bash
###### DESCRIPTION ######
* It makes an SD configuration, before the fisrt boot:
wifi, ssh, i2c, spi etc. based on previously set config file (rpitools_config.cfg)
#########################
```

* Unmount and disconnect the SD card from your computer. Take it to the pi, and power it up.
* Wait a little to boot up propely (max. 2-4 min.)

```
./3_remote_config_for_rpi_machine.bash
###### DESCRIPTION ######
* It copies all the rpitools repository to the raspberrypi
* Executes the rpitools/setup configuration sourcing
*** Based on your configuration (rpitools_config.cfg) it will prepare
your whole system.
* It takes 30-80 minutes (many installations and configurations with reboots)
#########################

./4_connect_and_enjoy.bash
###### DESCRIPTION ######
* FInally connect to your pi, and enjoy your NEW, PERSONAL environmat!
#########################
```

***WIRING***

######If you have our - offcial shild - just connect it to your raspberrypi.

#####RPITOOLS EXTENSION SHILED WIRING 1.0

![page_welcome](https://github.com/BxNxM/rpitools/blob/master/gpio/RPITOOLS_1.0_GPIO_PINOUT.png?raw=true)

***OLED BOOTUP LAUNCH SETUP - CONFIGURE A SERVICE (optional) [1]***

```
for more info:
oledinterface -h
```

* use virtual buttons LEFT / OK / RIGHT / standbyTrue / standbyFalse

```
oledinterface -b LEFT
oledinterface -b RIGHT
oledinterface -b OK
oledinterface -b stanbyTrue
oledinterface -b stanbyFalse
```

#### CUSTOMIZE OLED FRAMEWORK AND CREATE NEW PAGES (OPTIONAL)
* set default page 0 < - > page numbers in /home/$USER/rpitools/gpio/oled_128x64/lib/pages/ folder

```
vim /home/$USER/rpitools/gpio/oled_128x64/lib/.defaultindex.dat
```

* create your own page under

```
/home/$USER/rpitools/gpio/oled_128x64/lib/pages/page_XY.py
```
Change XY to the next page number

Use the example page resources under page folder, and create your own custom pages. List existing pages with:

```
List folder content:
llt /home/$USER/rpitools/gpio/oled_128x64/lib/pages
or
ls -lath /home/$USER/rpitools/gpio/oled_128x64/lib/pages
```

## oled framework main features
* draw text
* draw shapes: ellipse, rectangle, line, poligon
* draw image
* automatic functions: header bar (optional), page bar (optional), button handling
* automatic button handling (physical and virtual over oledinterface)
* page control, load, run in loop, unload, next, previus etc...

![page_welcome](https://github.com/BxNxM/rpitools/blob/master/template/demo_images/page_pi.jpg?raw=true)
![weather](https://github.com/BxNxM/rpitools/blob/master/template/demo_images/weather_page.jpg?raw=true)
![weather](https://github.com/BxNxM/rpitools/blob/master/template/demo_images/page_perf.jpg?raw=true)

## performance with default settings (medium)
RaspberryPi Zero W - get service CPU usage (average)

```
while true; do cpu=$(ps aux | grep -v grep | grep "oled_gui_core" | awk '{print $3}') && echo -ne "oledfw: $cpu %\r"; done
```

On MEDIUM performance set:

```
CPU LOAD: 25 % - 35 %
CPU if oled in STANDBY: 2.3 %
```

# BUILT IN KODI
```                            
  _  __   ____    _____    _____ 
 | |/ /  / __ \  |  __ \  |_   _|
 | ' /  | |  | | | |  | |   | |  
 |  <   | |  | | | |  | |   | |  
 | . \  | |__| | | |__| |  _| |_ 
 |_|\_\  \____/  |_____/  |_____|
                                           
``` 

***use hardware optimized media player for 720p and 180p videos***

```
run in command line:
kodibg
```

It gives you a full media player with many options. 
The video output goes to the dedicated HDMI connector.


# RGB interface
```
                 _       _           _                    __                       
                | |     (_)         | |                  / _|                      
  _ __    __ _  | |__    _   _ __   | |_    ___   _ __  | |_    __ _    ___    ___ 
 | '__|  / _` | | '_ \  | | | '_ \  | __|  / _ \ | '__| |  _|  / _` |  / __|  / _ \
 | |    | (_| | | |_) | | | | | | | | |_  |  __/ | |    | |   | (_| | | (__  |  __/
 |_|     \__, | |_.__/  |_| |_| |_|  \__|  \___| |_|    |_|    \__,_|  \___|  \___|
          __/ |                                                                    
         |___/                                                                     
```
To controll connected rgb leds.

* start rgb service - it controlls the leds - and process requests

```
rgbinterface -s ON
```

* turn on the leds

```
rgbinterface -l ON
```

* set colors

```
rgbinterface -r 0 -g 0 -b 0
rgbinterface -r 100 -g 100 -b 100

# color ranges: 0-100, min. step 1
```

* turn off the leds

```
rgbinterface -l OFF
```

* turn off the service

```
rgbinterface -s OFF
```
You don't have to turn off the service, it can runs in the background, so you can send data for it over rgbinterface and it makes the magic ;)

* show rgb leds service status

```
rgbinterface -sh
```

* interface help for informations

```
rgbinterface -h
```

# HAPTIC-ENGINE interface
```
  _    _              _____    _______   _____    _____   ______   _   _    _____   _____   _   _   ______ 
 | |  | |     /\     |  __ \  |__   __| |_   _|  / ____| |  ____| | \ | |  / ____| |_   _| | \ | | |  ____|
 | |__| |    /  \    | |__) |    | |      | |   | |      | |__    |  \| | | |  __    | |   |  \| | | |__   
 |  __  |   / /\ \   |  ___/     | |      | |   | |      |  __|   | . ` | | | |_ |   | |   | . ` | |  __|  
 | |  | |  / ____ \  | |         | |     _| |_  | |____  | |____  | |\  | | |__| |  _| |_  | |\  | | |____ 
 |_|  |_| /_/    \_\ |_|         |_|    |_____|  \_____| |______| |_| \_|  \_____| |_____| |_| \_| |______|
                                                                                                           
                                                                                                           
hapticengingeinterface -h

optional arguments:
  -h, --help        show this help message and exit
  -u, --up          HapticEngine UP signel
  -d, --down        HapticEngine DOWN signel
  -s, --soft        HapticEngine SOFT signel
  -t, --tap         HapticEngine TAP signel
  -dt, --doubletap  HapticEngine DoubleTAP signel
  -sn, --snooze     HapticEngine SNOOZE signel
```

# Your website
You have a custom website, with protected files web folder - like custom dropbox (cloud) on a private drive at home.
Get your internal or extarnal ip address and copy-paste it to your browser.

```
get your ip address on the pi:
sysmonitor -g
```

![website_1.0](https://github.com/BxNxM/rpitools/blob/master/template/demo_images/website1.0.png?raw=true)

# Useful links for basics
* RaspberryPi GPIO usage:

```
 https://sourceforge.net/p/raspberry-gpio-python/wiki/BasicUsage/
```

* GPIO pinout

```
https://pinout.xyz/pinout/pin1_3v3_power
```

* Download raspbian image (my project use the light version)

```
https://www.raspberrypi.org/downloads/raspbian/
```

* Raspbain image installation - manual - Windows / Mac / Linux

```
https://www.raspberrypi.org/documentation/installation/installing-images/
```

* My favourite raspberry pi order site (not sponsored - yet :P)

```
https://thepihut.com/products/raspberry-pi-zero-essential-kit
```

* Format disks

```
https://www.raspberrypi.org/forums/viewtopic.php?t=38429
```

* Useful - command line - commands collection

```
http://www.circuitbasics.com/useful-raspberry-pi-commands/
```

* Backup / Restore SDCard

```
https://thepihut.com/blogs/raspberry-pi-tutorials/17789160-backing-up-and-restoring-your-raspberry-pis-sd-card
http://bobbyromeo.com/technology/backup-clone-raspberry-pi-sd-card/
```

* Password protected apache folder setup

```
https://www.cyberciti.biz/faq/howto-setup-apache-password-protect-directory-with-htaccess-file/
```

## GIT
***push repo:*** git push -u origin master
