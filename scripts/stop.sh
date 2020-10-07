#!/usr/bin/env bash
#
#   hamenv
#   stop.sh     Stop all of the containers for the matching pattern
#

DOCKER_BIN=${DOCKER_BIN:-$(which docker)}

# get_containers
# Returns an array of container IDs matching the provided call sign
function get_containers() {
    local call=${1}
    local containers=$(${DOCKER_BIN} ps | grep -i ${call} | awk '{print $1}')
    echo ${containers}
}

if [ -z ${1} ]
then
    echo "ERROR: Missing call sign argument"
    echo "Usage: ${0} [call sign]"
    exit 1
fi

callsign=${1}
containers=$(get_containers ${1})
if [ ! -z ${containers} ]
then
    docker stop ${containers}
fi
echo "All containers for ${callsign} terminated"