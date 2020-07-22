#!/usr/bin/env bash
#
#

PROGRAM_DIR="/opt/Analog_Bridge"
CONFIG="/Analog_Bridge.ini"
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
    echo "Done"
fi

cd ${PROGRAM_DIR}
./Analog_Bridge ${CONFIG}