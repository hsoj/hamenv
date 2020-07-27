#!/usr/bin/env bash
#
#

PROGRAM_DIR="/opt/Analog_Bridge"
CONFIG="/Analog_Bridge.ini"
DVSWITCH_INI="/DVSwitch.ini"
CALLSIGN=${CALLSIGN:-N0CALL}
ANALOG_HOST=${ANALOG_HOST:-127.0.0.1}
ANALOG_OP_PORT=${ANALOG_PORT:-31100}
EMULATOR_HOST=${EMULATOR_HOST:-127.0.0.1}
EMULATOR_OP_PORT=${EMULATOR_PORT:-2470}
MMDVM_HOST=${MMDVM_ADDR:-127.0.0.1}
MMDVM_OP_PORT=${MMDVM_PORT:-32000}
MOBILE_CLIENT_OP_PORT=${MOBILE_CLIENT_PORT:-51100}
PLATFORM=${PLATFORM:-amd64}
REPEATER_ID=${REPEATER_ID:-00}

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
    sed -i "s/{{EMULATOR_HOST}}/${EMULATOR_HOST}/g" ${CONFIG}
    sed -i "s/{{EMULATOR_OP_PORT}}/${EMULATOR_OP_PORT}/g" ${CONFIG}
    sed -i "s/{{ANALOG_HOST}}/${ANALOG_HOST}/g" ${CONFIG}
    sed -i "s/{{ANALOG_OP_PORT}}/${ANALOG_OP_PORT}/g" ${CONFIG}
    sed -i "s/{{MMDVM_HOST}}/${MMDVM_HOST}/g" ${CONFIG}
    sed -i "s/{{MMDVM_OP_PORT}}/${MMDVM_OP_PORT}/g" ${CONFIG}
    sed -i "s/{{MOBILE_CLIENT_OP_PORT}}/${MOBILE_CLIENT_OP_PORT}/g" ${CONFIG}
    sed -i "s/{{DMR_ID}}/${DMR_ID}/g" ${CONFIG}
    sed -i "s/{{REPEATER_ID}}/${DMR_ID}${REPEATER_ID}/g" ${CONFIG}
    # Configure DVSwitch
    cp ${DVSWITCH_INI}.tmpl ${DVSWITCH_INI}
    sed -i "s/{{CALLSIGN}}/${CALLSIGN}/g" ${DVSWITCH_INI}
    sed -i "s/{{ANALOG_HOST}}/${ANALOG_HOST}/g" ${DVSWITCH_INI}
    sed -i "s/{{ANALOG_OP_PORT}}/${ANALOG_OP_PORT}/g" ${DVSWITCH_INI}
    sed -i "s/{{MMDVM_OP_PORT}}/${MMDVM_OP_PORT}/g" ${DVSWITCH_INI}
    # TODO: Figure out where this hardcoded value is getting set and determine 
    # the best way to avoid having to create this symlink
    ln -s ${DVSWITCH_INI} /opt/MMDVM_Bridge/DVSwitch.ini
    echo "Done"
fi

export DVSWITCH_INI

./Analog_Bridge ${CONFIG}