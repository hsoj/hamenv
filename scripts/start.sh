#!/usr/bin/env bash
#
#   Simple script to assist in starting up environments for individuals
#

# Source the common scripts
__DIR="${BASH_SOURCE%/*}"
. "${__DIR}/common.sh"

function print_help() {
    cat <<EOF
${0} -[cdrHACEM]

    -c, --callsign      The operator callsign
    -d, --dmr-id        The operator DMR ID
    -r, --repeater-id   The ID for the repeater
    -H, --host          The container host running the containers
    -A                  The port for the operator analog bridge container
    -C                  The port that the operator mobile device connects to
    -E                  The port for the operator emulator container
    -M                  The port for the operator DMR bridge container
EOF
}

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
            ANALOG_PORT=${2}
            shift
        ;;
        -C)
            MOBILE_CLIENT_PORT=${2}
            shift
        ;;
        -E)
            EMULATOR_PORT=${2}
            shift
        ;;
        -M)
            MMDVM_PORT=${2}
            shift
        ;;
        -h)
            print_help
            exit 0
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
    -p ${EMULATOR_PORT}:${EMULATOR_PORT}/udp \
    ${EMULATOR_IMAGE}:${emu_version}

# Start the MMDVM bridge
mmdvm_version=$(get_image_version ${MMDVM_IMAGE})
mmdvm_op_name="${MMDVM_IMAGE}_$(to_lower ${CALLSIGN})-${REPEATER_ID}"
docker run -d --rm --name ${mmdvm_op_name} \
    -p ${MMDVM_PORT}:${MMDVM_PORT}/udp \
    -e CALLSIGN=${CALLSIGN} \
    -e DMR_ID=${DMR_ID} \
    -e ANALOG_HOST=${HOST} \
    -e ANALOG_PORT=${ANALOG_PORT} \
    -e MMDVM_PORT=${MMDVM_PORT} \
    -e REPEATER_ID=${REPEATER_ID} \
    ${MMDVM_IMAGE}:${mmdvm_version}

# Start the Analog bridge
analog_version=$(get_image_version ${ANALOG_IMAGE})
analog_op_name="${ANALOG_IMAGE}_$(to_lower ${CALLSIGN})-${REPEATER_ID}"
docker run -d --rm --name ${analog_op_name} \
    -p ${ANALOG_PORT}:${ANALOG_PORT}/udp \
    -p ${MOBILE_CLIENT_PORT}:${MOBILE_CLIENT_PORT}/udp \
    -e CALLSIGN=${CALLSIGN} \
    -e DMR_ID=${DMR_ID} \
    -e ANALOG_HOST=${HOST} \
    -e ANALOG_PORT=${ANALOG_PORT} \
    -e EMULATOR_HOST=${HOST} \
    -e EMULATOR_PORT=${EMULATOR_PORT} \
    -e MMDVM_HOST=${HOST} \
    -e MMDVM_PORT=${MMDVM_PORT} \
    -e MOBILE_CLIENT_PORT=${MOBILE_CLIENT_PORT} \
    ${ANALOG_IMAGE}:${analog_version}