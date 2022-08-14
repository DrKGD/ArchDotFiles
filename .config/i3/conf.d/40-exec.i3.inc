#######################################################
## i3 - Run-on-startup applications									 ##
#######################################################

# Track CWD
exec_always --no-startup-id (killall -9 i3cwd.sh || true) && $HOME/.config/i3/sk/i3cwd.sh $MOUNTPOINT/cwd

# Compositor (picom) 
exec_always --no-startup-id "picom -b --backend glx --experimental-backends"

# alttab utility 
exec_always --no-startup-id "alttab -d 0 -p none -font \"xft:scientifica-12\" -t 128x60 -i 128x40 -fg \"#179aff\" -frame \"#ff9507\""

# polybar
exec_always --no-startup-id "$HOME/.config/polybar/launch.sh" 
