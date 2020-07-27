#
#   Added `.sh` extension just to make the syntax color coded
#

# Development configurations
BUILD_DIR=${BUILD_DIR:-"build"}
ANALOG_IMAGE=${ANALOG_IMAGE:-"analog-bridge"}
EMULATOR_IMAGE=${MD380_IMAGE:-"md380-emu"}
MMDVM_IMAGE=${MMDVM_IMAGE:-"mmdvm-bridge"}

# Operator configurations
CALLSIGN=${CALLSIGN:-""}
DMR_ID=${DMR_ID:-""}
REPEATER_ID=${REPEATER_ID:-00}

# Environment configurations
HOST=${HOST:-127.0.0.1}
ANALOG_HOST=${ANALOG_HOST:-$HOST}
ANALOG_PORT=${ANALOG_PORT:-31000}
ANALOG_OP_PORT=${ANALOG_OP_PORT:-$ANALOG_PORT}
EMULATOR_HOST=${EMULATOR_HOST:-$HOST}
EMULATOR_PORT=${EMULATOR_PORT:-2470}
EMULATOR_OP_PORT=${EMULATOR_OP_PORT:-$EMULATOR_PORT}
MMDVM_HOST=${MMDVM_HOST:-$HOST}
MMDVM_PORT=${MMDVM_PORT:-32000}
MMDVM_OP_PORT=${MMDVM_OP_PORT:-$MMDVM_PORT}
MOBILE_CLIENT_PORT=${MOBILE_CLIENT_PORT:-51100}
MOBILE_CLIENT_OP_PORT=${MOBILE_CLIENT_OP_PORT:-$MOBILE_CLIENT_PORT}

# docker_build_image builds the image with the provided name tagged with the 
# provided version.
function docker_build_image() {
    local image_name="${1}"
    local image_version="${2}"
    docker build -t ${image_name}:${image_version} ${BUILD_DIR}/${image_name}/
}

# docker_images returns an array of all of the images and their versions that 
# are installed on the configured host.
function docker_images() {
    local images=$(docker images | awk '{printf "%s:%s\n", $1, $2}' | tail -n +2)
    echo "${images[@]}"
}

# docker_image_version_exists checks if an image with the provided name and 
# version already exist within the Docker container host.
function docker_image_version_exists() {
    local image_name="${1}"
    local image_version="${2}"
    local check=$(docker_images | grep ${image_name} | grep ${image_version})
    echo ${check}
}

# get_image_version returns the current value of the VERSION file in the 
# provided image's build directory.
function get_image_version() {
    local image_name="${1}"
    echo $(cat ${BUILD_DIR}/${image_name}/VERSION)
}

# to_lower returns the input string as all lower-cased characters
function to_lower() {
    local in_string="${1}"
    echo "${in_string}" | tr '[:upper:]' '[:lower:]'
}