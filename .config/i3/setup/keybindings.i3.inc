#######################################################
## i3 - Global defined keybindings									 ##
#######################################################

## Mouse
floating_modifier $leader
focus_follows_mouse no 

## Allow moving between monitors
force_focus_wrapping no

# Don't move mouse on focus change
mouse_warping none

## Change focus
bindsym $leader+h focus left
bindsym $leader+j focus down
bindsym $leader+k focus up
bindsym $leader+l focus right

## Move windows around around
bindsym $leader+$shift+h move left
bindsym $leader+$shift+j move down
bindsym $leader+$shift+k move up
bindsym $leader+$shift+l move right

# Run program
bindsym $leader+slash exec "rofi -modi drun,run -show drun"

# Show programs
bindsym $leader+Tab exec rofi -show window

# Enter fullscreen
bindsym $leader+f fullscreen toggle

# Toggle floating 
bindsym $leader+$enter floating toggle

# Kill current focussed window
bindsym $leader+q kill
bindsym $altkey+F4 kill

# Reload xrdb current profile
set_from_resource $xrdbconfig	de.configuration $HOME/.config/xrdb/profile/desktop

# Reload configuration (and xrdb configs)
bindsym $leader+grave exec --no-startup-id reload 
bindsym $leader+$shift+grave exec --no-startup-id xrdb -remove && xrdb -override $HOME/.Xresources && xrdb -override $xrdbconfig && i3-msg 'restart'

# Split vertical or horizontal 
bindsym $leader+v split h
bindsym $leader+s split v 

## Volume Control
# Use pactl to adjust volume in PulseAudio
set $refresh_i3status killall -SIGUSR1 i3status
bindsym XF86AudioRaiseVolume exec --no-startup-id $sk/volume_sanification.sh @DEFAULT_SINK@ +5
bindsym XF86AudioLowerVolume exec --no-startup-id $sk/volume_sanification.sh @DEFAULT_SINK@ -5
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status

# Use keyboard
bindsym $leader+equal exec --no-startup-id $sk/volume_sanification.sh @DEFAULT_SINK@ +4
bindsym $leader+minus exec --no-startup-id $sk/volume_sanification.sh @DEFAULT_SINK@ -4

# Cycle through workspace(s) on the current screen
bindsym $leader+bracketleft workspace prev_on_output
bindsym $leader+bracketright workspace next_on_output

# TODO: Handle screenshots in i3
