#!/usr/bin/env bash
#

BUILD_DIR=${BUILD_DIR:-build}
FORCE=${FORCE:-0}
TARGET=""

# build_docker Function that takes an image name and it's version and runs the 
# build process for the directory within the BUILD_DIR
function build_docker() {
    local image_name="${1}"
    local image_version="${2}"
    docker build -t ${image_name}:${image_version} ${BUILD_DIR}/${image_name}
}

# get_images Function to get all of the images available on the configured 
# Docker container host.
function get_images() {
    local images=$(docker images | awk '{printf "%s:%s\n", $1, $2}' | tail -n +2)
    echo "${images[@]}"
}

# get_image_version Function to check the configured Docker host to determine 
# if a container image with the provided name and version already exists.
function get_image_version() {
    local image_name="${1}"
    local image_version="${2}"
    local image_check=$(get_images | grep "${image_name}" | grep "${image_version}")
    echo "${image_check}"
}

# print_help Prints out the help message and exits 0
function print_help() {
    cat <<EOF
${0} [-h] [-f] [-t target_image]

    -h      Prints this message
    -f      Forces a rebuild of the image(s)
    -t      Target a specific container image to be built
EOF
    exit 1
}

# Get the options passed if any
while (($#))
do
    case "${1}" in
        -f)
            FORCE=1
        ;;
        -t)
            TARGET=${2}
            shift
        ;;
        -h)
            print_help
        ;;
    esac
    shift
done

# If there was not a single target provided, get all of the available images 
# that exist within the BUILD_DIR and make that the target.
if [ -z "${TARGET}" ]
then
    TARGET=$(ls "${BUILD_DIR}")
fi

# Iterate over the target
for image_name in ${TARGET[@]}
do
    image_version=$(cat ${BUILD_DIR}/${image_name}/VERSION)
    if [[ ${FORCE} -eq 1 ]] || [[ -z $(get_image_version ${image_name} ${image_version}) ]]
    then
        build_docker ${image_name} ${image_version}
    fi
done
