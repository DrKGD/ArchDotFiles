#######################################################
## i3 - Laptop specific settings										 ##
#######################################################

## Move to the next workspace
bindsym $leader+Left workspace prev 
bindsym $leader+Right workspace next 

#######################################################
## i3 - Workspaces and all        									 ##
#######################################################

# Workspaces
set $wm1 "   Term I"
set $wm2 "  Term II"
set $wm3 "      Nav"
set $wm4 "   Social"
set $wm5 "    Media"
set $wm6 "    Focus"
set $wm7 "    Focus"
set $wm8 "嗢    Misc"
set $wm9 "	   Setup"

# Move between workspaces
bindsym $leader+1 workspace $wm1
bindsym $leader+2 workspace $wm2
bindsym $leader+3 workspace $wm3
bindsym $leader+4 workspace $wm4
bindsym $leader+5 workspace $wm5
bindsym $leader+6 workspace $wm6
bindsym $leader+7 workspace $wm7
bindsym $leader+8 workspace $wm8
bindsym $leader+9 workspace $wm9

# Move window to workspaces
bindsym $leader+$shift+1 move container to workspace $wm1
bindsym $leader+$shift+2 move container to workspace $wm2
bindsym $leader+$shift+3 move container to workspace $wm3
bindsym $leader+$shift+4 move container to workspace $wm4
bindsym $leader+$shift+5 move container to workspace $wm5
bindsym $leader+$shift+6 move container to workspace $wm6
bindsym $leader+$shift+7 move container to workspace $wm7
bindsym $leader+$shift+8 move container to workspace $wm8
bindsym $leader+$shift+9 move container to workspace $wm9
