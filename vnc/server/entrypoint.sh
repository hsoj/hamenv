#!/usr/bin/env bash
#

DISPLAY=${DISPLAY:-:1}

tigervncserver -localhost yes -SecurityTypes None -xstartup /usr/bin/startxfce4 $DISPLAY