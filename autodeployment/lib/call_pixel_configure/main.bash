#!/bin/bash

MYPATH="${BASH_SOURCE[0]}"
MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# RPIENV SETUP (BASH)
if [ -e "${MYDIR}/.rpienv" ]
then
    source "${MYDIR}/.rpienv" "-s" > /dev/null
    # check one var from rpienv - check the path
    if [ ! -f "$CONFIGHANDLER" ]
    then
        echo -e "[ ENV ERROR ] \$CONFIGHANDLER path not exits!"
        echo -e "[ ENV ERROR ] \$CONFIGHANDLER path not exits!" >> /var/log/rpienv
        exit 1
    fi
else
    echo -e "[ ENV ERROR ] ${MYDIR}/.rpienv not exists"
    sudo bash -c "echo -e '[ ENV ERROR ] ${MYDIR}/.rpienv not exists' >> /var/log/rpienv"
    exit 1
fi

source "${TERMINALCOLORS}"

source "${MYDIR}/../message.bash"
_msg_title="PIXEL GUI"

# pixel install config executor
pixel_install="$($CONFIGHANDLER -s INSTALL_PIXEL -o activate)"
if [ "$pixel_install" == "True" ] || [ "$pixel_install" == "true" ]
then
    _msg_ "RUN: PIXEL install"
    ("${REPOROOT}/prepare/system/install_PIXEL.bash")
else
    _msg_ "PIXEL install is not requested"
fi
