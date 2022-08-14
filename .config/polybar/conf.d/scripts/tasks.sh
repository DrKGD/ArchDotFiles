#!/bin/bash

# Locate module(s) position
export readonly SPATH=$(echo "$0" | xargs dirname)

# Include module(s)
. "${SPATH}/formatter.sh"

# Set parameters
readonly DEFAULT_OUTPUT="$(i3-msg -t get_outputs | jq -r ".[] | select(.primary=="true") | .name")"
readonly WATCH="${1:-${WATCH:-$DEFAULT_OUTPUT}}"

## Available formats
# @name				=> Application name as defined in the switch, if not found, returns classname instead
# @shortname	=> Application name as defined in the switch, but shortened 
# @icon				=> Application icon as defined in the switch, if not found, returns default-icon instead
# @classname	=> Classname property of the application
# @abscount		=> Number of application of the same type on the current workspace, one-inclusive
# @count			=> defined if abscount>1, otherwise null

readonly FORMAT="${2:-${FORMAT:-@abscount\x@icon @name}}"
readonly SEPARATOR="${3:-${SEPARATOR:- }}"

# Sanity check
if [[ -z "$WATCH" ]]; then
	echo '$WATCH was not set!'; exit 1;
elif [[ -z $(i3-msg -t get_outputs | jq -r ".[] | select(.name==\"$WATCH\") | .active") ]]; then
	echo "$WATCH output does not exist!"; exit 1; 
fi

# Make format using 
make_format "${FORMAT}"

# Core functionality
loop (){
	## Get current workspace from watched output
	WORKSPACE="$(i3-msg -t get_outputs | jq -r ".[] | select(.name==\"$WATCH\") | .current_workspace")"

	## Retrieve classes from current workspace
	OUTPUT=
	while read class; do
		# Prepare string
		ABSCOUNT="$(echo $class | cut -d';' -f 1)"
		COUNT="$([[ ABSCOUNT -gt 1 ]] && echo $ABSCOUNT || printf %b '\u200b')"
		CLASSNAME="$(echo $class | cut -d';' -f 2)"

		case $CLASSNAME in
			'org.wezfurlong.wezterm') NAME="WezTerm";			ICON=""; SHORTNAME="WZ";;
			'firefox')								NAME="FireFox";			ICON=""; SHORTNAME="FF";;
			'dolphin')								NAME="Dolphin";			ICON=""; SHORTNAME="DH";;
			'TelegramDesktop')				NAME="Telegram";		ICON=""; SHORTNAME="TG";;
			*)												NAME="$CLASSNAME";	ICON="ﬓ"; SHORTNAME="${CLASSNAME:0:2}" ;;
		esac

		OUTPUT+="$(make_string)$SEPARATOR"
	done < <(i3-msg -t get_tree | jq -r ".nodes[] | select(.name==\"$WATCH\") | .nodes[] | select(.name==\"content\") | .nodes[] | select(.name==\"$WORKSPACE\") | .. | .window_properties? // empty | .class" | sort | uniq -c | sed -e 's/^ *//;s/ /;/')

	echo $OUTPUT | sed "s/\(.*\)$SEPARATOR/\1/"
}

## Init & Scan for processes 
loop
while read -r event; do
	loop
done < <(i3-msg -m -t subscribe '[ "window" ]')
