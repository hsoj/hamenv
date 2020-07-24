#!/usr/bin/env bash
#
#

PROGRAM_DIR="/opt/Analog_Bridge"
CONFIG="/Analog_Bridge.ini"
DVSWITCH_INI="/DVSwitch.ini"
EMULATOR_ADDR=${EMULATOR_ADDR:-127.0.0.1}
EMULATOR_PORT=${EMULATOR_PORT:-2470}
ANALOG_ADDR=${ANALOG_ADDR:-127.0.0.1}
MMDVM_ADDR=${MMDVM_ADDR:-127.0.0.1}
PLATFORM=${PLATFORM:-amd64}
SSID=${SSID:-00}

# Check if the configuration file exists and populate it if it does not
if [ ! -f ${CONFIG} ]
then
    if [ ! ${DMR_ID} ]
    then
        echo "No DMR ID provided, exiting."
        exit 1
    fi
    # TODO: Update the following to leverage an actual templateing system
    # instead of forcing these configurations through sed
    echo -n "Configuring the analog bridge..."
    cp ${CONFIG}.tmpl ${CONFIG}
    sed -i "s/{{EMULATOR_ADDR}}/${EMULATOR_ADDR}/g" ${CONFIG}
    sed -i "s/{{EMULATOR_PORT}}/${EMULATOR_PORT}/g" ${CONFIG}
    sed -i "s/{{ANALOG_ADDR}}/${ANALOG_ADDR}/g" ${CONFIG}
    sed -i "s/{{MMDVM_ADDR}}/${MMDVM_ADDR}/g" ${CONFIG}
    sed -i "s/{{DMR_ID}}/${DMR_ID}/g" ${CONFIG}
    sed -i "s/{{SSID}}/${DMR_ID}${SSID}/g" ${CONFIG}
    # Configure DVSwitch
    cp ${DVSWITCH_INI}.tmpl ${DVSWITCH_INI}
    sed -i "s/{{ANALOG_ADDR}}/${ANALOG_ADDR}/g" ${DVSWITCH_INI}
    # TODO: Figure out where this hardcoded value is getting set and determine 
    # the best way to avoid having to create this symlink
    ln -s ${DVSWITCH_INI} /opt/MMDVM_Bridge/DVSwitch.ini
    echo "Done"
fi

export DVSWITCH_INI

./Analog_Bridge ${CONFIG}