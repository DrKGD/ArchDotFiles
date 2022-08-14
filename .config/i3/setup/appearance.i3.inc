#######################################################
## i3 - Appearance																	 ##
#######################################################

# Read xrdb(s)
set_from_resource $border-size	i3.border.size							3
set_from_resource $gap-outer		i3.gap.outer								5
set_from_resource $gap-inner		i3.gap.inner								5

## Gaps, Borders
for_window [class=".*"] border pixel $border-size 
hide_edge_borders both 

# Global configuration
gaps outer $gap-outer
gaps inner $gap-inner

# Colors 
set_from_resource $focus				i3.color.focus							#ffffff 
set_from_resource $elegible			i3.color.elegible						#ffffff 
set_from_resource $nofocus			i3.color.no-focus						#ffffff 
set_from_resource $urgent				i3.color.urgent  						#ffffff 
set_from_resource $ind					i3.color.indicator					#ffffff
set_from_resource $indelg				i3.color.elegibleindicator	#ffffff
set_from_resource $unknown			i3.color.unknown						#000000

## Colors
# class										border		backgr.		text			indicator		child_border
client.focused						$unknown	$unknown	$unknown	$ind				$focus	
client.focused_inactive 	$unknown 	$unknown	$unknown	$indelg			$elegible
client.unfocused					$unknown 	$unknown	$unknown 	$unknown		$nofocus
client.urgent							$unknown	$unknown	$unknown 	$urgent			$urgent
client.placeholder				$unknown	$unknown	$unknown	$unknown		$unknown
client.background					$unknown

## Font
font pango:monospace 8

# NetworkManager is the most popular way to manage wireless networks on Linux,
# and nm-applet is a desktop environment-independent system tray GUI for it.
exec --no-startup-id nm-applet

## Bar
set_from_resource $font					i3.font											scientifica


## TODO: Replace with polybar
# bar {
# 	status_command i3status
# 	font pango:$font
# }
