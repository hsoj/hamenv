#!/usr/bin/env bash
#

DISPLAY=${DISPLAY:-:1}

Xvnc -UseIPv6=0 -SecurityTypes=None $DISPLAY