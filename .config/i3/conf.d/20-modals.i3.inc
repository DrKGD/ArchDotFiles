#######################################################
## i3 - Modes and modal keybindings									 ##
#######################################################
set $apps_browser firefox
set $apps_incognito firefox --private-window --
set $apps_terminal wezterm
set $apps_cwdTerminal wezterm start --cwd $(cat $MOUNTPOINT/cwd)
set $apps_editor vscode
set $apps_fileExplorer dolphin
set $apps_whatsapp firefox --new-window https://web.whatsapp.com

set $mode_run run
set $mode_media media
set $mode_system sudo
set $mode_edit edit

## Modes
# Run binded applications
bindsym $leader+r mode $mode_run
mode $mode_run {
		# Run explorer 
		bindsym e exec $apps_fileExplorer, mode "default"

		# Telegram 
		bindsym t exec telegram-desktop, mode "default"

		# Terminal
		bindsym Return exec $apps_terminal, mode "default"
		bindsym Shift+Return exec $apps_cwdTerminal, mode "default"

		# Whatsapp 
		bindsym w exec $apps_whatsapp, mode "default"

		# Browser
		bindsym b exec $apps_browser, mode "default"

		# Browser in incognito 
		bindsym Shift+b exec $apps_incognito, mode "default"

		# Exit
		bindsym Escape mode "default"
	}
 
# Media (music, youtube ...) control
bindsym $leader+p mode $mode_media
mode $mode_media {
		# Player play-pause 
		bindsym space exec playerctl play-pause 

		# Player control
		bindsym Right exec playerctl next
		bindsym Left exec playerctl previous

		# Volume Control
		bindsym equal exec playerctl volume +5
		bindsym minus exec playerctl volume -5

		# Exit
		bindsym Escape mode "default"
	}

# System commands
bindsym $leader+$shift+r mode $mode_system
mode $mode_system {
		# Volume Control
		bindsym equal exec --no-startup-id $sk/volume_sanification.sh @DEFAULT_SINK@ +4
		bindsym minus exec --no-startup-id $sk/volume_sanification.sh @DEFAULT_SINK@ -4

		# logout 
		bindsym s exec "i3-nagbar -t warning -m 'Do you really want to shutdown the computer?' -B 'Yes' 'shutdown -h now'"
		bindsym l exec "i3-nagbar -t warning -m 'Do you really want to logout?' -B 'Yes' 'i3-msg exit'"

		bindsym Return mode "default"
		bindsym Escape mode "default"
		bindsym $leader+Escape mode "default"
	}

# Edit (resize 'n such)
bindsym $leader+e mode $mode_edit
mode $mode_edit {
		# These bindings trigger as soon as you enter the resize mode

		# Pressing left will shrink the window’s width.
		# Pressing right will grow the window’s width.
		# Pressing up will shrink the window’s height.
		# Pressing down will grow the window’s height.
		bindsym h resize shrink width 10 px or 10 ppt
		bindsym j resize grow height 10 px or 10 ppt
		bindsym k resize shrink height 10 px or 10 ppt
		bindsym l resize grow width 10 px or 10 ppt

		# same bindings, but for the arrow keys
		bindsym Left resize shrink width 10 px or 10 ppt
		bindsym Down resize grow height 10 px or 10 ppt
		bindsym Up resize shrink height 10 px or 10 ppt
		bindsym Right resize grow width 10 px or 10 ppt

		# back to normal: Enter or Escape or $mod+r
		bindsym Return mode "default"
		bindsym Escape mode "default"
		bindsym $leader+e mode "default"
	}


