#!/bin/bash

# Do nothing if SCREENS was not previously defined
if [ -z ${SCREENS+x} ]; then echo "SCREENS not defined in the env!"; exit 1; fi

# Requires new brightness level
if [ $# -eq 0 ]; then echo "No arguments supplied!"; exit 1; fi
readonly AMOUNT=$1; shift

# Filter out the requested ones
readonly FILTER="$(IFS='|'; echo "$*")"
if [ $# -eq 0 ]; then readonly SELECTION=$SCREENS;
else readonly SELECTION=$(echo "$SCREENS" | sed -En "/(${FILTER})/!p");
fi

# Dim screens
xrandr $(echo "$SELECTION" | xargs -I{} echo -n "--output {} --brightness ${AMOUNT} ")
