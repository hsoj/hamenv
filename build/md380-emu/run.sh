#!/usr/bin/env bash
#
#

PROGRAM_DIR="/opt/md380-emu"
PORT=${PORT:-2470}

qemu-arm-static ${PROGRAM_DIR}/md380-emu -S ${PORT}