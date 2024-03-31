#!/usr/bin/env bash

DISPLAY=${DISPLAY:-:1}
VNC_HOST=${VNC_HOST:-localhost}
VNC_PORT=${VNC_PORT:-5901}

/noVNC/utils/novnc_proxy --web /noVNC --vnc $VNC_HOST:$VNC_PORT --listen 6080