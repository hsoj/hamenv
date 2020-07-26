#!/usr/bin/env bash
#
#

BUILD_DIR="build"
IMAGES=(
    "md380-emu"
    "analog-bridge"
    "mmdvm-bridge"
)

function get_images() {
    images=$(docker images | awk '{printf "%s:%s\n", $1, $2}' | tail -n +2)
    echo "${images[@]}"
}

function image_version_exists() {
    image_name="${1}"
    image_version="${2}"
    install_chk=$(get_images | grep "${image_name}" | grep "${image_version}")
    echo "${install_chk}"
}

for i in ${IMAGES[@]}
do
    build_path="${BUILD_DIR}/${i}"
    version=$(cat "${build_path}/VERSION")
    image_exists=$(image_version_exists "${i}" "${version}")
    if [ -z "${image_exists}" ]
    then
        docker build -t ${i}:${version} "${build_path}"
    fi
done