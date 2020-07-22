#!/usr/bin/env bash
#
#

BUILD_PATH="build"
IMAGES=$(ls "${BUILD_PATH}")
HOST=${HOST:-$(env | grep DOCKER_HOST | awk -F\: '{printf "%s\n", $2}' | sed "s|//||g")}
ANALOG_ADDR=${ANALOG_ADDR:-${HOST}}
EMULATOR_ADDR=${EMULATOR_ADDR:-${HOST}}
MMDVM_ADDR=${MMDVM_ADDR:-${HOST}}

if [ -f .env ]
then
    . .env
fi

if [ -z ${CALLSIGN} ]
then
    echo "Error: The CALLSIGN environment variable is not set."
    exit 1
fi

if [ -z ${DMR_ID} ]
then
    echo "Error: The DMR_ID environment variable is not set."
    exit 1
fi

if [ -z ${HOST} ]
then
    echo "Error: No HOST is defined either directly or via DOCKER_HOST."
    exit 1
fi

function container_running() {
    name="${1}"
    version="${2}"
    check=$(docker ps -f name=${name} | tail -n +2 | awk '{print $2}' | awk -F\: '{print $2}')
    if [ "${check}" == "${version}" ]
    then
        echo "${version}"
    fi
}

# TODO: Put the following into Ansible.

# Ensure that the md380 emulator container is running
# TODO: Add better port exposure handling.
md380_image="md380-emu"
md380_name=${MD380_NAME:-${md380_image}}
md380_path="${BUILD_PATH}/${md380_image}"
md380_version=${MD380_VERSION:-$(cat "${md380_path}/VERSION")}
if [ -z $(container_running "${md380_name}" "${md380_version}") ]
then
    docker stop ${md380_name}
    docker rm ${md380_name}
    docker run -d --name ${md380_name} ${md380_image}:${md380_version}
fi

# Ensure that the MMDVM bridge container is running
# TODO: Add better port exposure handling.
mmdvm_image="mmdvm-bridge"
mmdvm_name=${MMDVM_NAME:-${mmdvm_image}}
mmdvm_path="${BUILD_PATH}/${mmdvm_image}"
mmdvm_version=${MMDVM_VERSION:-$(cat "${mmdvm_path}/VERSION")}
if [ -z $(container_running "${mmdvm_name}" "${mmdvm_version}") ]
then
    docker stop ${mmdvm_name}
    docker rm ${mmdvm_name}
    docker run -d --name ${mmdvm_name} \
        -e CALLSIGN=${CALLSIGN} \
        -e DMR_ID=${DMR_ID} \
        -e ANALOG_ADDR=${ANALOG_ADDR} \
        ${mmdvm_image}:${mmdvm_version}
fi

# Ensure that the analog bridge container is running
# TODO: Add better port exposure handling.
analog_image="analog-bridge"
analog_name=${ANALOG_NAME:-${analog_image}}
analog_path="${BUILD_PATH}/${analog_name}"
analog_version=${ANALOG_VERSION:-$(cat "${analog_path}/VERSION")}
if [ -z $(container_running "${analog_name}" "${analog_version}") ]
then
    docker stop ${analog_name}
    docker rm ${analog_name}
    docker run -d --name ${analog_name} \
        -e DMR_ID=${DMR_ID} \
        -e ANALOG_ADDR=${ANALOG_ADDR} \
        -e EMULATOR_ADDR=${EMULATOR_ADDR} \
        -e MMDVM_ADDR=${MMDVM_ADDR} \
        ${analog_image}:${analog_version}
fi