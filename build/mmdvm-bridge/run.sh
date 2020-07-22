#!/usr/bin/env bash
#
#

REPEATER_ID=${REPEATER_ID:-00}
LATITUDE=${LATITUDE:-0}
LONGITUDE=${LONGITUDE:-0}
LOCATION=${LOCATION:-UNKNOWN}
DESCRIPTION=${DESCRIPTION:-hamenv Bridge}
BM_ADDR=${BM_ADDR:-3101.repeater.net}
BM_PASSWD=${BM_PASSWD:-passw0rd}
ANALOG_ADDR=${ANALOG_ADDR:-127.0.0.1}

CONFIG=/MMDVM_Bridge.ini
PROGRAM_PATH=/opt/MMDVM_Bridge

if [ ! -f ${CONFIG} ]
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
    cp ${CONFIG}.tmpl ${CONFIG}
    sed -i "s/{{CALLSIGN}}/${CALLSIGN}/g" ${CONFIG}
    sed -i "s/{{DMR_BM}}/${DMR_ID}${REPEATER_ID}/g" ${CONFIG}
    sed -i "s/{{LATITUDE}}/${LATITUDE}/g" ${CONFIG}
    sed -i "s/{{LONGITUDE}}/${LONGITUDE}/g" ${CONFIG}
    sed -i "s/{{LOCATION}}/${LOCATION}/g"  ${CONFIG}
    sed -i "s/{{DESCRIPTION}}/${DESCRIPTION}/g" ${CONFIG}
    sed -i "s/{{BM_ADDR}}/${BM_ADDR}/g" ${CONFIG}
    sed -i "s/{{BM_PASSWD}}/${BM_PASSWD}/g" ${CONFIG}
    # TODO: Modify this so that it doesn't just use the blanket config.
    # TODO: Make the a variable?  It's not like it can be modified from the 
    # directory that the bridge binary is executed from and has a hard coded
    # name.
    cp DVSwitch.ini.tmpl DVSwitch.ini
    sed -i "s/{{ANALOG_ADDR}}/${ANALOG_ADDR}/g" DVSwitch.ini
fi

${PROGRAM_PATH}/MMDVM_Bridge ${CONFIG}