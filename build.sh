#!/usr/bin/env bash
#
#   Helper script to ensure that containers are built in a proper order.
#

# Container images in order of dependcy
IMAGES=(
    "dvswitch"
    "md380-emu"
    "analog-bridge"
)

for i in ${IMAGES[*]}
do
    image_path="build/${i}"
    version=$(cat ${image_path}/VERSION)
    docker build -t ${i}:${version} ${image_path}
done