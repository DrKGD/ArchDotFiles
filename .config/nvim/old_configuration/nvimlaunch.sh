#!/usr/bin/env bash

### Env variables
export readonly EXSIGNAL=17
export readonly UPSIGNAL=18
export readonly PID=$$

### Costants
readonly SESSIONPATH=~/.local/share/nvim/
readonly SESSION="-S ${SESSIONPATH}${PID}.lastSession"

### Variables
EXCODE=$UPSIGNAL
export NVIMSET=

## Encapsulate nvim 
while [ $EXCODE -eq $EXSIGNAL ] || [ $EXCODE -eq $UPSIGNAL ]; do 
	# Run nvim
	case $EXCODE in
		# Restart neovim keeping the session alive, and sending parameters through
		$EXSIGNAL)
		nvim $SESSION $@ $NVIMSET
		;;

		# Restart neovim with the same parameters
		$UPSIGNAL)
		nvim $@ $NVIMSET
		;;
	esac

	# Wait nvim process to quit, get its exitcode
	EXCODE=$?
done

# Delete last session if not null
rm -f "${SESSIONPATH}${PID}.lastSession"
