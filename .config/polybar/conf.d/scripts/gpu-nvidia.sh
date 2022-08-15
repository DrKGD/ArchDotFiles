#!/bin/bash

# Locate module(s) position
export readonly SPATH=$(echo "$0" | xargs dirname)

# Include module(s)
. "${SPATH}/formatter.sh"

# Set parameters 
readonly DELAY="${1:-${DELAY:-0.5}}"

## Available formats
# @name			=> Name of the GPU 
# @vendor 	=> Vendor of the GPU 
# @temp			=> Current temperature of the GPU in C°
# @usage		=> % Usage of the GPU 
# @fan			=> % Fan speed of the GPU
# @wattcurr => Current watt usage of the GPU in watts 
# @wattmax  => Max allowed watt usage for the GPU in watts
# @vramcurr => Current VRAM usage of the GPU in MBs
# @vrammax  => Total VRAM of the GPU in MBs
readonly FORMAT="${2:-${FORMAT:-@name}}"

_GPU_COMMAND="gpustat --show-fan-speed --show-power --watch ${DELAY} --no-header --no-color"

# Get name 
_CARD_INFO="$(gpustat --no-header --no-color --json | jq -r '.gpus[0].name')"
VENDOR="$(echo "$_CARD_INFO" | cut -d' ' -f 1)"
NAME="$(echo "$_CARD_INFO" | cut --complement -d' ' -f 1,2)"

# Make format using 
make_format "${FORMAT}"

# Retrieve which GPU-tool once
while read -r line; do 
	## GPU temperature (No symbols)
	TEMP=$(echo "$line" | awk '{print $7}'); TEMP=${TEMP%"'C,"}

	## GPU fan speed (percent)
	FAN=$(echo "$line" | awk '{print "%03d", $8}')

	## GPU Usage (in %)
	USAGE=$(echo "$line" | awk '{printf "%03d",$10}')

	## GPU watt usage
	WATTCURR=$(echo "$line" | awk '{printf "%03d",$12}')
	WATTMAX=$(echo "$line" | awk '{printf "%03d",$14}')

	## GPU ram usage
	VRAMCURR=$(echo "$line" | awk '{printf "%05d",$17}')
	VRAMMAX=$(echo "$line" | awk '{printf "%05d",$19}')

	# Update using the format string
	make_string
done < <($_GPU_COMMAND)



