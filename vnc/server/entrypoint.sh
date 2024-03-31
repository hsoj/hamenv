#!/usr/bin/env bash
#

DISPLAY=${DISPLAY:-:1}

/etc/init.d/dbus start
tigervncserver -fg -localhost yes -SecurityTypes None -xstartup /usr/bin/startxfce4 -geometry 1024x768 $DISPLAY