#######################################################
## i3 - Modes and modal keybdings 									 ##
#######################################################

## Modes
# Run binded applications
bindsym $leader+r mode $eggxe
mode $eggxe {
		# Run explorer 
		bindsym e exec $explorer, mode "default"

		# Telegram 
		bindsym t exec telegram-desktop, mode "default"

		# Terminal
		bindsym $enter exec $terminal, mode "default"
		bindsym $shift+$enter exec $cwdterminal, mode "default"

		# Whatsapp 
		bindsym w exec $whatsapp, mode "default"

		# Browser
		bindsym b exec $browser, mode "default"

		# Browser in incognito 
		bindsym $shift+b exec $incognito, mode "default"

		# Exit
		bindsym $esc mode "default"
	}
 
# Media (music, youtube ...) control
bindsym $leader+p mode $eggme
mode $eggme {
		# Player play-pause 
		bindsym space exec playerctl play-pause 

		# Player control
		bindsym Right exec playerctl next
		bindsym Left exec playerctl previous

		# Volume Control
		bindsym equal exec playerctl volume +5
		bindsym minus exec playerctl volume -5

		# Exit
		bindsym $esc mode "default"
	}


# System commands
bindsym $leader+$shift+r mode $eggse
mode $eggse {
		# Volume Control
		bindsym equal exec --no-startup-id $sk/volume_sanification.sh @DEFAULT_SINK@ +4
		bindsym minus exec --no-startup-id $sk/volume_sanification.sh @DEFAULT_SINK@ -4

		# logout 
		bindsym s exec "i3-nagbar -t warning -m 'Do you really want to shutdown the computer?' -B 'Yes' 'shutdown -h now'"
		bindsym l exec "i3-nagbar -t warning -m 'Do you really want to logout?' -B 'Yes' 'i3-msg exit'"

		bindsym $enter mode "default"
		bindsym $esc mode "default"
		bindsym $leader+$esc mode "default"
	}


# Edit (resize 'n such)
bindsym $leader+e mode $egged
mode $egged {
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
		bindsym $enter mode "default"
		bindsym $esc mode "default"
		bindsym $mod+r mode "default"
		bindsym $leader+e mode "default"
	}

