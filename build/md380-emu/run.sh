#!/usr/bin/env bash
#
#

PROGRAM_DIR="/opt/md380-emu"
PORT=${PORT:-2470}

echo "Starting md380 emulator: $(date '+%Y%m%d %H:%M:%S')"
qemu-arm-static ${PROGRAM_DIR}/md380-emu -S ${PORT} -vv