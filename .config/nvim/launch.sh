#!/bin/bash

## Export environment variable
export readonly SIGKEEP=20
export readonly SIGDISCARD=30
export readonly BACK_UP="/mnt/fdrive/backup/nvim/"

## Session filepath
readonly NVIM_SESSION_FPATH="${MOUNTPOINT:-$XDG_DATA_HOME}/nvim/"
readonly NVIM_SESSION_FNAME="$$.session"
export readonly PID_SESSION="${NVIM_SESSION_FPATH}${NVIM_SESSION_FNAME}"
export readonly PID_GARBAGE="${NVIM_SESSION_FPATH}$$.rm/"

## Make folder at location to keep sessions
mkdir -p "$NVIM_SESSION_FPATH" "$PID_GARBAGE"

## Run neovim
echo "Session file will be kept at <$PID_SESSION>!"
echo "Removed files will be kept in <$PID_GARBAGE>!"
echo "Now launching nvim..."

nvim $@
EXCODE=$?

## Run neovim until exit code is not $SIGKEEP
while [ $EXCODE -eq $SIGKEEP ] || [ $EXCODE -eq $SIGDISCARD ]; do
	case $EXCODE in
		# Restart nvim, thus keeping the session (if file exists)
		$SIGKEEP)
			echo "Restarting (keep) nvim..."
			nvim -S "$PID_SESSION" $@
			;;

		$SIGDISCARD)
			echo "Restarting (clean) nvim..."
			nvim $@
			;;
	esac

	# Wait for nvim to exit
	EXCODE=$?
done

## Delete session 
rm -f "$PID_SESSION"
echo "Goodbye"

