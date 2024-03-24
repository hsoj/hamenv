#!/usr/bin/env bash
#
#   Script to compile the md380 emulator
#

SOURCE_PATH="${SOURCE_PATH:-/src}"
ARTIFACT_NAME="md380-emu"
ARTIFACT_PATH="${ARTIFACT_PATH:-/dist}"
EMULATOR_SOURCE_PATH="${EMULATOR_SOURCE_PATH:-${SOURCE_PATH}/emulator}"
FIRMWARE_SOURCE_PATH="${FIRMWARE_SOURCE_PATH:-${SOURCE_PATH}/firmware}"

# Ensure the firmware is downloaded
if [ ! -d "${FIRMWARE_SOURCE_PATH}" ]
then
    echo "Error: No firmware source found at path [${FIRMWARE_SOURCE_PATH}]"
    exit 1
fi
cd "${FIRMWARE_SOURCE_PATH}"
make clean download

# Compile the emulator
if [ ! -d "${EMULATOR_SOURCE_PATH}" ]
then
    echo "Error: No emulator source found at path [${EMULATOR_SOURCE_PATH}]"
    exit 1
fi
cd "${EMULATOR_SOURCE_PATH}"
make clean all
if [ -f "${EMULATOR_SOURCE_PATH}/${ARTIFACT_NAME}" ]
then
    mv "${EMULATOR_SOURCE_PATH}/${ARTIFACT_NAME}" \
        "${ARTIFACT_PATH}/${ARTIFACT_NAME}"
fi