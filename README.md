![logo](https://github.com/BxNxM/rpitools/blob/master/template/demo_images/logo.png?raw=true)

# =========================
# ======= RPITOOLS ========
# =========================

# CONFIGURATION
***Deploy and setup raspbain image on MacOS/Linux***

* clone rpi repo from github
* 
```
git clone https://github.com/BxNxM/rpitools.git
```

* go to rpitools/prepare_sd
* 
```
cd rpitools/prepare_sd
```

* Copy raspbian image to the rpitools/prepare\_sd/raspbian\_img folder
* 
```
cp ~/Downloads/*raspbian*.img raspbian_img/
```

* run the sd card imager and follow the instructions
* 
```
./raspbian_imager.bash
```

* configure raspbian image on sd card (ssh, wifi, usb-eth, video ram) - follow the instructions
* 
```
./boot_config.bash
```

* set your wifi ssid and password on the wpa_supplicant.conf file
* 
```
-> manually (wifi) setup /Volumes/boot/wpa_supplicant.conf file.
```

* ***FINALLY: unmount SD card, put it in the rpi zero w***

* After raspberry booted up - copy rpitools (from your computer) to the raspberrypi
* 
```
copy rpitools:
(if needed: ssh-keygen -R raspberrypi.local)
cd rpitools/prepare_sd
rm -f raspbian_img/*.img && scp -r ../../rpitools/ pi@raspberrypi.local:~/
(default pwd: raspberry)
```
* SSH to the pi
* 
```
ssh pi@raspberrypi.local
(default pwd: raspberry)
```
***Configuration on  YOUR PI with rpitools***

* Source rpitools - install / setup / configure
* 
```
cd rpitools/
source setup
```

* if you use raspbain lite, and you want a GUI
* 
```
./install_PIXEL.bash
```

* if you want remote desktop access
* 
```
./install_vnc.bash
```

* Finally some manual setups with rpi-tools (don't forget)
* 
```
set default login console/desktop
location
expand file system
screen resolution
set local name
```

# ==== OLED FRAMEWORK ===
![oled]()

SUPPORTED OLED TYPE: 128x64 i2c SSD1306 Driver IC


####Enable i2c interface with raspi-config

```
sudo raspi-config
```
-> interfacing options - > i2c

***''Install'' and set boot start with one script :D***

```
cd /home/$USER/rpitools/gpio/oled_128x64/systemd_setup/
./set_service.bash
```

* manage oled service over systemd:

```
sudo systemctl status oled_gui_core
sudo systemctl restart oled_gui_core
sudo systemctl start oled_gui_core
sudo systemctl stop oled_gui_core
```

* use virtual buttons LEFT / OK / RIGHT

```
oledinterface -b LEFT
oledinterface -b RIGHT
oledinterface -b OK
```

* set default page 0 < - > page numbers in /home/$USER/rpitools/gpio/oled_128x64/lib/pages/ folder

```
vim /home/$USER/rpitools/gpio/oled_128x64/lib/.defaultindex.dat
```

* create your own page under
```
/home/$USER/rpitools/gpio/oled_128x64/lib/pages/page_<x>.py
```
Change <x> to the next page number

Use the example page resources under page folder, and create your own custom pages. Pages folder path with default pages:

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

![page_welcome]()


## GIT
***push repo:*** git push -u origin master
