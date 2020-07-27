#!/usr/bin/env bash
#
#

EMULATOR_PORT=${EMULATOR_PORT:-2470}

echo "Starting md380 emulator: $(date '+%Y%m%d %H:%M:%S')"
qemu-arm-static /md380-emu -S ${EMULATOR_PORT} -vv