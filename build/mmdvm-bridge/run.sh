#!/usr/bin/env bash
#
#

ANALOG_HOST=${ANALOG_HOST:-127.0.0.1}
ANALOG_OP_PORT=${ANALOG_OP_PORT:-31100}
MMDVM_OP_PORT=${MMDVM_OP_PORT:-32000}
BM_ADDR=${BM_ADDR:-3101.repeater.net}
BM_PORT=${BM_PORT:-62031}
BM_LOCAL_PORT=${BM_LOCAL_PORT:-62032}
BM_PASSWD=${BM_PASSWD:-passw0rd}
REPEATER_ID=${REPEATER_ID:-00}
LATITUDE=${LATITUDE:-0}
LONGITUDE=${LONGITUDE:-0}
LOCATION=${LOCATION:-UNKNOWN}
DESCRIPTION=${DESCRIPTION:-hamenv Bridge}
URL=${URL:-"https://qrz.com/db/${CALLSIGN}"}


MMDVM_PORT=${MMDVM_PORT:-31101}

export DVSWITCH_INI=${DVSWITCH_INI:-/DVSwitch.ini}
export MMDVM_DIR=${MMDVM_DIR:-/}
export MMDVM_INI=${MMDVM_INI:-/MMDVM_Bridge.ini}

if [ ! -f ${MMDVM_INI} ]
then
    # TODO: Simplify the process of ensuring values are set for required 
    # variables.
    if [ -z ${CALLSIGN} ]
    then
        echo "No Callsign provided, exiting."
        exit 1
    fi
    if [ -z ${DMR_ID} ]
    then
        echo "No DMR ID provided, exiting."
        exit 1
    fi
    # TODO: Implament an actual templating engine instead of the manual string 
    # replace.
    cp ${MMDVM_INI}.tmpl ${MMDVM_INI}
    sed -i "s/{{CALLSIGN}}/${CALLSIGN}/g" ${MMDVM_INI}
    sed -i "s/{{DMR_BM}}/${DMR_ID}${REPEATER_ID}/g" ${MMDVM_INI}
    sed -i "s/{{LATITUDE}}/${LATITUDE}/g" ${MMDVM_INI}
    sed -i "s/{{LONGITUDE}}/${LONGITUDE}/g" ${MMDVM_INI}
    sed -i "s/{{LOCATION}}/${LOCATION}/g"  ${MMDVM_INI}
    sed -i "s/{{DESCRIPTION}}/${DESCRIPTION}/g" ${MMDVM_INI}
    # Change the string replace character to comply with characters valid in a 
    # URL
    sed -i "s|{{URL}}|${URL}|g" ${MMDVM_INI}
    sed -i "s/{{BM_ADDR}}/${BM_ADDR}/g" ${MMDVM_INI}
    sed -i "s/{{BM_PORT}}/${BM_PORT}/g" ${MMDVM_INI}
    sed -i "s/{{BM_LOCAL_PORT}}/${BM_LOCAL_PORT}/g" ${MMDVM_INI}
    sed -i "s/{{BM_PASSWD}}/${BM_PASSWD}/g" ${MMDVM_INI}
    # TODO: Modify this so that it doesn't just use the blanket config.
    # TODO: Make the a variable?  It's not like it can be modified from the 
    # directory that the bridge binary is executed from and has a hard coded
    # name.
    cp ${DVSWITCH_INI}.tmpl ${DVSWITCH_INI}
    sed -i "s/{{ANALOG_HOST}}/${ANALOG_HOST}/g" ${DVSWITCH_INI}
    sed -i "s/{{ANALOG_OP_PORT}}/${ANALOG_OP_PORT}/g" ${DVSWITCH_INI}
    sed -i "s/{{CALLSIGN}}/${CALLSIGN}/g" ${DVSWITCH_INI}
    sed -i "s/{{MMDVM_OP_PORT}}/${MMDVM_OP_PORT}/g" ${DVSWITCH_INI}
fi

/MMDVM_Bridge ${MMDVM_INI}