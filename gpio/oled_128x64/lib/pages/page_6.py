import subprocess
import time
import os
import sys

# import memory dict client
sys.path.append("/home/pi/rpitools/tools/socketmem/lib/")
import clientMemDict
socketdictclient = clientMemDict.SocketDictClient()

#################################################################################
#                            joystick_elements rgb widget                       #
#                              ----------------------------                     #
#                                 ON/OFF R,G,B VALUES                           #
#################################################################################
rgb_joystick_elements = None

def page_setup(display, joystick_elements):
    display.head_page_bar_switch(True, True)
    display.display_refresh_time_setter(0.1)
    rgb_manage_function(joystick_elements, display, joystick=None, mode="init")
    cmd_alias = "/home/$USER/rpitools/gpio/rgb_led/bin/rgb_interface.py -s ON"
    run_command(cmd_alias, display)

def page(display, joystick, joystick_elements):
    uid, state, value = rgb_manage_function(joystick_elements, display, joystick, mode="run")

    if state is not None:
        if uid == "rgbbutton":
            button = "OFF"
            if state:
                button = "ON"
            socketdictclient.run_command("-md -n rgb -k LED -v " + str(button))

        if uid == "red":
            socketdictclient.run_command("-md -n rgb -k RED -v " + str(value))
        if uid == "green":
            socketdictclient.run_command("-md -n rgb -k GREEN -v " + str(value))
        if uid == "blue":
            socketdictclient.run_command("-md -n rgb -k BLUE -v " + str(value))
    return True

def page_destructor(display, joystick_elements):
    cmd_alias = "/home/$USER/rpitools/gpio/rgb_led/bin/rgb_interface.py -s OFF -l OFF"
    run_command(cmd_alias, display, wait_for_done=False)
    rgb_manage_function(joystick_elements, display, joystick, mode="del")

#################################################################################
#execute command and wait for the execution + load indication
def run_command(cmd, display=None, wait_for_done=True):
    x = 95
    y = 45
    if display is not None:
        w, h = display.draw_text("load", x, y)
    p = subprocess.Popen(cmd, shell=True)
    if wait_for_done:
        p.communicate()
    if display is not None:
        w, h = display.draw_text("    ", x, y)

#################################################################################
def rgb_manage_function(joystick_elements, display, joystick, mode=None):
    global rgb_joystick_elements

    # init section
    if mode == "init":
        default_value = 30

        # init value elemet for red color
        je_red = joystick_elements.JoystickElement_value_bar(display, x=5, step=10, valmax=100, valmin=0, title="R")
        je_red.set_value(delta=default_value)
        # set led state:
        cmd_alias = "/home/$USER/rpitools/gpio/rgb_led/bin/rgb_interface.py -r {}".format(default_value)
        subprocess.Popen(cmd_alias, shell=True)

        # init value elemet for green color
        je_green = joystick_elements.JoystickElement_value_bar(display, x=35, step=10, valmax=100, valmin=0, title="G")
        je_green.set_value(delta=30)
        # set led state:
        cmd_alias = "/home/$USER/rpitools/gpio/rgb_led/bin/rgb_interface.py -g {}".format(default_value)
        subprocess.Popen(cmd_alias, shell=True)

        # init value elemet for green color
        je_blue = joystick_elements.JoystickElement_value_bar(display, x=65, step=10, valmax=100, valmin=0, title="B")
        je_blue.set_value(delta=30)
        # set led state:
        cmd_alias = "/home/$USER/rpitools/gpio/rgb_led/bin/rgb_interface.py -b {}".format(default_value)
        subprocess.Popen(cmd_alias, shell=True)

        # rgb on - off
        je_rgb_button = joystick_elements.JoystickElement_button(display, x=95, title="RGB")

        # init button handler - and element manager list with created elements
        rgb_joystick_elements = joystick_elements.JoystickElementManager(default_index=3)
        rgb_joystick_elements.add_element(je_red, "red")                        # object, uid (id to get value change)
        rgb_joystick_elements.add_element(je_green, "green")
        rgb_joystick_elements.add_element(je_blue, "blue")
        rgb_joystick_elements.add_element(je_rgb_button, "rgbbutton")
        time.sleep(1)

    # run change check on elemets list - return cahnge
    if mode == "run":
        change = rgb_joystick_elements.run_elements(joystick)
        if change[0] is not None:
            print("#"*100)
            print("uid: " + str(change[0]) + " state: " + str(change[1]) + " value: " + str(change[2]))
            print("#"*100)
        return change

    # delete created object!
    if mode == "del":
        del rgb_joystick_elements
