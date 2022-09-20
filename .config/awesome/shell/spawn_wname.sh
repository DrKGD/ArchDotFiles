#!/bin/bash

command="$1"
set -x;
DESKTOP_STARTUP_ID="INJECT" $command &
# _pid=$!
# _wid=$(xdotool search --sync --pid $_pid)
# xprop -set SATISFIES_RULE "$2" -id "$_wid"
# xprop -id "$_wid"
# set +x;
# echo "$_wid"
