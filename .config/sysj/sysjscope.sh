#!/bin/bash
set -eo pipefail

 ######
########
##    ##
##   ## 
##  ##
#### 
##  ##
##   ## eader 
##   ##
##   ##
##

# Defaults
SCOPE="$1"
SYSJGEN="${SYSJGEN:-$MOUNTPOINT/configuration.json}"

if [ -z "$SCOPE" ]; then
	echo "SCOPE was not specified!" >&2
	exit 1 
fi

if [ ! -f "$SYSJGEN" ]; then
	echo "<${SYSJGEN}> configuration .json file was not found, was it generated previously?" >&2
	exit 1 
fi

case $SCOPE in
	'i3') PREFIX='set $' ; ASSIGN=' '; PRECOMMENT='';;
	*)		echo "<$SCOPE> not recognized!"; exit 1;;
esac

while IFS= read -r line; do
	echo "$PRECOMMENT$line"
done <<< "$HEADER"
echo

jq -r --arg SCOPE $SCOPE --arg PREFIX "$PREFIX" --arg ASSIGN "$ASSIGN" \
	'.[$SCOPE] | paths(scalars) as $p | "\($PREFIX)\($p|join("_"))\($ASSIGN)\(getpath($p))"' "$SYSJGEN" 
