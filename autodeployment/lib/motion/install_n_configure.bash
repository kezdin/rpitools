#!/bin/bash

MYPATH="${BASH_SOURCE[0]}"
MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
confighandler="/home/$USER/rpitools/autodeployment/bin/ConfigHandlerInterface.py"
motion_target_folder="$($confighandler -s MOTION -o target_folder)"
motion_activate="$($confighandler -s MOTION -o activate)"

source "${MYDIR}/../../../prepare/colors.bash"
motion_conf_path="/etc/motion/motion.conf"              # https://tutorials-raspberrypi.com/raspberry-pi-security-camera-livestream-setup/
motion_conf_path2="/etc/default/motion"                 # start_motion_daemon=yes
add_modeprobe_to="/etc/modules-load.d/raspberrypi.conf"
initial_config_done_indicator="/home/$USER/rpitools/cache/.motion_initial_config_done"

_msg_title="MOTION SETUP"
function _msg_() {
    local msg="$1"
    echo -e "${LIGHT_PURPLE}[ $_msg_title ]${NC} - $msg"
}

function change_line() {
    local from="$1"
    local to="$2"
    local where="$3"
    if [ ! -z "$from" ]
    then
        _msg_ "sudo cat $where | grep -v grep | grep $to\nis_set: $is_set"
        is_set="$(sudo cat "$where" | grep -v grep | grep "$to")"
        _msg_ "$is_set"
        if [ "$is_set" == "" ]
        then
            _msg_ "${GREEN}Set parameter (full line): $to  (from: $from) ${NC}"
            #sudo sed -i 's|'"${from}"'\c|'"${to}"'|g' "$where"
            sudo sed -i '/'"${from}"'/c\'"${to}"'' "$where"
        else
            _msg_ "${GREEN}Custom config line $to already set in $where ${NC}"
        fi
    fi
}

function install() {
    output=$(command -v "motion")
    if [ -z "$output" ]
    then
        _msg_ "Install motion (camera handler service)."
        sudo apt-get install motion -y
    else
        _msg_ "motion is already installed."
    fi
}

function configure() {
    if [ "$(cat "$add_modeprobe_to" | grep 'bcm2835-v4l2')" == "" ]
    then
        _msg_ "Add / Activate kernel module: bcm2835-v4l2"
        sudo modprobe bcm2835-v4l2
        echo "bcm2835-v4l2\n" >> "$add_modeprobe_to"
    else
        _msg_ "Kernel module bcm2835-v4l2 already added and avtivated."
    fi

    _msg_ "Get camera details:"
    camera_details="$(v4l2-ctl -V)"
    _msg_ "$camera_details"

    _msg_ "Edit $motion_conf_path conf."
    change_line "daemon off" "daemon on" "$motion_conf_path"
    change_line "target_dir" "target_dir $motion_target_folder" "$motion_conf_path"
    change_line "v4l2_palette" "v4l2_palette 15" "$motion_conf_path"
    change_line "width 640" "width 800" "$motion_conf_path"
    change_line "height 480" "height 400" "$motion_conf_path"
    change_line "framerate" "framerate 10" "$motion_conf_path"
    change_line "locate_motion_mode off" "locate_motion_mode on" "$motion_conf_path"

    _msg_ "Edit $motion_conf_path2 conf."
    change_line "start_motion_daemon=no" "start_motion_daemon=yes" "$motion_conf_path2"

    if [ ! -d "$motion_target_folder" ]
    then
        _msg_ "Create and set $motion_target_folder"
        mkdir -p "$motion_target_folder"
        sudo chgrp motion "$motion_target_folder"
        chmod g+rwx "$motion_target_folder"
    else
        _msg_ "$motion_target_folder already exists."
    fi
}

function execute() {
    _msg_ "START MOTION: sudo systemctl start motion"
    sudo service motion start
    #sudo systemctl start motion
    #sudo systemctl enable motion
}

if [[ "$motion_activate" == "true" ]] || [[ "$motion_activate" == "True" ]]
then
    _msg_ "Motion install and config required"
    if [ ! -f "$initial_config_done_indicator" ]
    then
        install
        configure
        echo -e "$(date)" > "$initial_config_done_indicator"
    else
        _msg_ "Initial install and config done, $initial_config_done_indicator exists."
    fi
    execute
elif [[ "$motion_activate" == "false" ]] || [[ "$motion_activate" == "False" ]]
then
    _msg_ "Motion install and configured NOT required"
    sudo systemctl stop motion
    sudo systemctl disable motion
else
    _msg_ "Invalid parameter: $motion_activate => True or False"
fi
