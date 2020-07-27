#!/usr/bin/env bash
#

. "${BASH_SOURCE%/*}/common.sh"

FORCE=${FORCE:-0}
TARGET=${TARGET:-""}

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
    image_dir="${BUILD_DIR}/${image_name}"
    image_version=$(get_image_version ${image_name})
    image_exists=$(docker_image_version_exists ${image_name} ${image_version})
    if [[ ${FORCE} -eq 1 ]] || [[ -z ${image_exists} ]]
    then
        # If there is a Dockerfile assume the build is for a docker image
        if [ -f ${image_dir}/Dockerfile ]
        then
            docker_build_image ${image_name} ${image_version}
        fi
    fi
done
