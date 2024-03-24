#!/usr/bin/env bash
#
#
set -e

EMULATOR_PORT=${EMULATOR_PORT:-2470}
# echo "Trying to start emulator on ${EMULATOR_PORT}"
qemu-arm-static /md380-emu -S ${EMULATOR_PORT} -vv