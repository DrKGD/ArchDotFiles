#!/bin/bash
set -eo pipefail

##    ##
##   ## 
##  ##
#### 
##  ##
##   ## onfigurator
##   ##
##   ##
##

# Defaults
SYSJCFG="${SYSJCFG:-$HOME/.config/sysj/config}"
PROFILE="${PROFILE:-default}"

if [ ! -f "$SYSJCFG" ]; then
	echo "<${SYSJCFG}> configuration .json file was not found, does it exist?" >&2
	exit 1 
fi

## Load initial configuration
CONFIG="$(jq -n 'reduce inputs as $s (.; (.[input_filename|rtrimstr(".json")]) += $s)' $(cat $SYSJCFG) |\
						jq 'to_entries | map({key: ( .key | match("([^\/]*$)") | .captures[0].string ) , value: ( .value.default * (.value.desktop? // {} ) ) }) | from_entries')"


## Add theme
readonly THEMES="$(jq -r '.general.file.themes' <<< "$CONFIG" | envsubst)"
readonly TH="$(jq -r '.general.theme' <<< "$CONFIG" )"
readonly TH_JSON="$(jq --arg TH $TH '.[$TH]' "$THEMES")"
CONFIG="$(jq --argjson TH_JSON "$TH_JSON" '. += { theme: $TH_JSON }' <<< "$CONFIG")"

## Process indirect keys
# TODO: Enable recursion
IND_KEYS="$(echo "$CONFIG" | jq -r 'paths(strings) as $paths | (getpath($paths) | select(contains("ind:")) | sub("ind";($paths|join("."))))')"
for icomp in $IND_KEYS; do
	in="$(echo "$icomp" | cut -d':' -f1)"
	ik="$(echo "$icomp" | cut -d':' -f2)"
	iv="$(echo "$CONFIG" | jq -re ".$ik")"

	CONFIG="$(echo "$CONFIG" | jq -e ".$in = \"$iv\"")"
done

echo $CONFIG | jq
