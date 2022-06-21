#######################################################
## i3 - Appearance																	 ##
#######################################################

## Gaps, Borders
for_window [class=".*"] border pixel 2, split horizontal 
hide_edge_borders both 

# Gaps between windows, gaps from top of the screen (polybar)
gaps top 2
gaps bottom 2
gaps left 2
gaps right 2
gaps inner 6 

## Colors
# class										border  backgr. text    indicator child_border
client.focused					#ffffff #ffffff #ffffff #179aff		#ff9507
client.focused_inactive #ffffff #ffffff #ffffff #004ffd		#552f00
client.unfocused				#ffffff #ffffff #ffffff #004ffd		#552f00
client.urgent						#2f343a #900000 #ffffff #900000		#900000
client.placeholder			#000000 #0c0c0c #ffffff #000000		#0c0c0c
client.background				#ffffff

# Allow moving between monitors
force_focus_wrapping no
