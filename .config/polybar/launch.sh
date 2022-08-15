#!/bin/bash
# set -eo pipefall

# Kill all polybars
killall -q polybar >/dev/null 2>&1 || true

case $PROFILE in
	desktop)
			BARS='desk-top desk-bot desk-lx desk-rx'
		;;
	laptop)
			BARS='lap-top lap-bot'
		;;
esac

# Run polybar with the loaded configuration
for bar in $BARS; do
	nohup polybar "$bar" </dev/null >/tmp/polybar.log 2>&1 & disown
done
