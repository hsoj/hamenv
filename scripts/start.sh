#!/usr/bin/env bash
#
#   Simple script to assist in starting up environments for individuals
#

# Source the common scripts
__DIR="${BASH_SOURCE%/*}"
. "${__DIR}/common.sh"

# Gather all of the arguments passed and override any current configurations
while (($#))
do
    case "${1}" in
        -c|--callsign)
            CALLSIGN=${2}
            shift
        ;;
        -d|--dmr-id)
            DMR_ID=${2}
            shift
        ;;
        -r|--repeater-id)
            REPEATER_ID=${2}
            shift
        ;;
        -H|--host)
            HOST=${2}
            shift
        ;;
        -A)
            ANALOG_OP_PORT=${2}
            shift
        ;;
        -C)
            MOBILE_CLIENT_OP_PORT=${2}
            shift
        ;;
        -E)
            EMULATOR_OP_PORT=${2}
            shift
        ;;
        -M)
            MMDVM_OP_PORT=${2}
            shift
        ;;
    esac
    shift
done

if [ -z ${CALLSIGN} ]
then
    echo "ERROR: No callsign provided, exiting."
    exit 1
fi

if [ -z ${DMR_ID} ]
then
    echo "ERROR: No DMR ID provided, exiting."
    exit 1
fi

if [ -z ${HOST} ]
then
    echo "ERROR: No host provided, exiting."
    exit 1
fi

#  Start the emulator
emu_version=$(get_image_version ${EMULATOR_IMAGE})
emu_op_name="${EMULATOR_IMAGE}_$(to_lower ${CALLSIGN})-${REPEATER_ID}"
docker run -d --rm --name ${emu_op_name} \
    -p ${EMULATOR_OP_PORT}:${EMULATOR_PORT}/udp \
    ${EMULATOR_IMAGE}:${emu_version}

# Start the MMDVM bridge
mmdvm_version=$(get_image_version ${MMDVM_IMAGE})
mmdvm_op_name="${MMDVM_IMAGE}_$(to_lower ${CALLSIGN})-${REPEATER_ID}"
docker run -d --rm --name ${mmdvm_op_name} \
    -p ${MMDVM_OP_PORT}:${MMDVM_PORT}/udp \
    -e CALLSIGN=${CALLSIGN} \
    -e DMR_ID=${DMR_ID} \
    -e ANALOG_HOST=${HOST} \
    -e ANALOG_OP_PORT=${ANALOG_OP_PORT} \
    -e MMDVM_OP_PORT=${MMDVM_OP_PORT} \
    -e REPEATER_ID=${REPEATER_ID} \
    ${MMDVM_IMAGE}:${mmdvm_version}

# Start the Analog bridge
analog_version=$(get_image_version ${ANALOG_IMAGE})
analog_op_name="${ANALOG_IMAGE}_$(to_lower ${CALLSIGN})-${REPEATER_ID}"
docker run -d --rm --name ${analog_op_name} \
    -p ${ANALOG_OP_PORT}:${ANALOG_PORT}/udp \
    -p ${MOBILE_CLIENT_OP_PORT}:${MOBILE_CLIENT_PORT}/udp \
    -e CALLSIGN=${CALLSIGN} \
    -e DMR_ID=${DMR_ID} \
    -e ANALOG_HOST=${HOST} \
    -e ANALOG_OP_PORT=${ANALOG_OP_PORT} \
    -e EMULATOR_HOST=${HOST} \
    -e EMULATOR_OP_PORT=${EMULATOR_OP_PORT} \
    -e MMDVM_HOST=${HOST} \
    -e MMDVM_OP_PORT=${MMDVM_OP_PORT} \
    ${ANALOG_IMAGE}:${analog_version}