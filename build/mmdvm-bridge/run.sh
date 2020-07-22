#!/usr/bin/env bash
#
#

REPEATER_ID=${REPEATER_ID:-00}
LATITUDE=${LATITUDE:-0}
LONGITUDE=${LONGITUDE:-0}
LOCATION=${LOCATION:-UNKNOWN}
DESCRIPTION=${DESCRIPTION:-hamenv Bridge}
URL=${URL:-"https://qrz.com/db/${CALLSIGN}"}
BM_ADDR=${BM_ADDR:-3101.repeater.net}
BM_PASSWD=${BM_PASSWD:-passw0rd}
ANALOG_ADDR=${ANALOG_ADDR:-127.0.0.1}

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
    sed -i "s/{{BM_PASSWD}}/${BM_PASSWD}/g" ${MMDVM_INI}
    # TODO: Modify this so that it doesn't just use the blanket config.
    # TODO: Make the a variable?  It's not like it can be modified from the 
    # directory that the bridge binary is executed from and has a hard coded
    # name.
    cp ${DVSWITCH_INI}.tmpl ${DVSWITCH_INI}
    sed -i "s/{{ANALOG_ADDR}}/${ANALOG_ADDR}/g" ${DVSWITCH_INI}
fi

/MMDVM_Bridge ${MMDVM_INI}