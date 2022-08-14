#!/bin/bash

# Locate module(s) position
export readonly SPATH=$(echo "$0" | xargs dirname)

# Include module(s)
. "${SPATH}/formatter.sh"

# Set parameters 
readonly DELAY="${1:-${DELAY:-0.5}}"


## Available formats
# @use => In use RAM 
# @max => Total RAM
readonly FORMAT="${2:-${FORMAT:-@use : @max}}"

# Make format using 
make_format "${FORMAT}"

# Main loop
while true; do
	# Read output in MBytes
	read -r USE MAX <<< "$(free -m | awk '$1 ~ /Mem:/ {printf "%05d %05d",$3,$2}')"

	# Update using the format string
	make_string
	sleep $DELAY
done


