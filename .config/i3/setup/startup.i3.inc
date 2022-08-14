#######################################################
## i3 - Run-on-startup applications									 ##
#######################################################

# Current working directory
exec_always --no-startup-id (killall -9 i3cwd.sh || true) && $HOME/.config/i3/sk/i3cwd.sh $MOUNTPOINT/cwd

# Compositor (picom) 
exec_always --no-startup-id "picom -b --backend glx --experimental-backends"

# Static background img 
set_from_resource $bgimage i3.background $HOME/.config/i3/desktop.bg.png
exec_always --no-startup-id xwallpaper --no-randr --tile $bgimage

# alttab utility 
exec_always --no-startup-id "alttab -d 0 -p none -font \"xft:scientifica-12\" -t 128x60 -i 128x40 -fg \"#179aff\" -frame \"#ff9507\""

# polybar (do not refresh configuration)
exec_always --no-startup-id "$HOME/.config/polybar/launch.sh n" 
