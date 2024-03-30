#!/bin/bash

# Check if DISPLAY environment variable is set
if [ -z "$DISPLAY" ]; then
    echo "DISPLAY environment variable is not set. Please set it to the appropriate display environment path."
    exit 1
fi

# Start Xorg server
Xorg -listen tcp -noreset +extension RANDR +extension RENDER \
    -config /etc/X11/xorg.conf $DISPLAY