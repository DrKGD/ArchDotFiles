#!/bin/bash

if [[ $# -ne 1 ]]; then
	echo "Expecting write location" >&2
	exit 2
fi

WRITE_POSITION=$1; shift;
echo $HOME > $WRITE_POSITION

while read -r line; do
	json="$(echo $line |	jq -r '.change + ";" + .container.window_properties.class')"

	event="$(echo $json | cut -d ';' -f 1)"
	case $event in
		'focus')
				focus="$(echo $json | cut -d ';' -f 2)"

				case $focus in
					'org.wezfurlong.wezterm')
						wezterm cli list | tr -s ' ' | awk -F ' ' \
							-v focus="$(wezterm cli list-clients | tail -1 | tr -s ' ' | cut -d ' ' -f 7)" \
							'$3==focus {print $7}' | sed 's/^file:\/\/[^/]*//g' > $WRITE_POSITION
						;;

					*) echo "unhandled focus: <${focus}>";;
				esac
			;;

		*) echo "unhandled event: <${event}>" ;;
	esac
done < <(i3-msg -m -t subscribe '[ "window" ]')


