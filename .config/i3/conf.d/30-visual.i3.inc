#######################################################
## i3 - Appearance																	 ##
#######################################################

set $border_size 3
set $gap_outer 3 
set $gap_inner 5

## Gaps, Borders
for_window [class=".*"] border pixel $border_size 
hide_edge_borders both 

# Global configuration
gaps outer $gap_outer
gaps inner $gap_inner

# Color configuration 
set $color_focus #FC0344
set $color_elegible #750A26
set $color_nofocus #520016
set $color_urgent #FD5D88
set $color_indicator #FD5D88
set $color_elgindicator #FC0344
set $color_unknown #000000

## Colors
# class										border					backgr					text						indicator					child_border
client.focused						$color_unknown	$color_unknown	$color_unknown	$color_indicator $color_focus	
client.focused_inactive 	$color_unknown 	$color_unknown	$color_unknown	$color_elgindicator $color_elegible
client.unfocused					$color_unknown 	$color_unknown	$color_unknown 	$color_unknown		$color_nofocus
client.urgent							$color_unknown	$color_unknown	$color_unknown 	$color_urgent			$color_urgent
client.placeholder				$color_unknown	$color_unknown	$color_unknown	$color_unknown		$color_unknown
client.background					$color_unknown
