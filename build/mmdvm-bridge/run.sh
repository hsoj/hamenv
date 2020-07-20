#!/usr/bin/env bash
#
#

REPEATER_ID=${REPEATER_ID:-00}
BM_ID=${BM_ID:-${DMR_ID}${REPEATER_ID}}
LATITUDE=${LATITUDE:-0}
LONGITUDE=${LONGITUDE:-0}
LOCATION=${LOCATION:-UNKNOWN}
DESCRIPTION=${DESCRIPTION:-hamenv Bridge}
BM_ADDR=${BM_ADDR:-3101.repeater.net}

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
    if [ -z ${BM_PASSWD} ]
    then
        echo "No password for brandmeister provided, exiting."
        exit 1
    fi
    # TODO: Implament an actual templating engine instead of the manual string 
    # replace.
    cp ${CONFIG}.tmpl ${CONFIG}
    sed -i "s/{{CALLSIGN}}/${CALLSIGN}/g" ${CONFIG}
    sed -i "s/{{DMR_BM}}/${DMR_ID}${BM_ID}/g" ${CONFIG}
    sed -i "s/{{LATITUDE}}/${LATITUDE}/g" ${CONFIG}
    sed -i "s/{{LONGITUDE}}/${LONGITUDE}/g" ${CONFIG}
    sed -i "s/{{LOCATION}}/${LOCATION}/g"  ${CONFIG}
    sed -i "s/{{DESCRIPTION}}/${DESCRIPTION}/g" ${CONFIG}
    sed -i "s/{{BM_ADDR}}/${BM_ADDR}/g" ${CONFIG}
    sed -i "s/{{BM_PASSWD}}/${BM_PASSWD}/g" ${CONFIG}
    # TODO: Modify this so that it doesn't just use the blanket config.
    cp DVSwitch.ini.tmpl DVSwitch.ini
fi

${PROGRAM_PATH}/MMDVM_Bridge ${CONFIG}