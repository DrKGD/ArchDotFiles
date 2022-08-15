#######################################################
## i3 - Desktop specific settings										 ##
#######################################################
## i3 - Specific configuration                       ##
#######################################################
set $dimamount 0.35
set $output_sx_screen DP-1
set $output_cx_screen DVI-I-1
set $output_dx_screen HDMI-0
set $output_tv_screen DVI-D-0

#######################################################
## i3 - Specific bindings        										 ##
#######################################################

## Move to the next output
bindsym $leader+Left exec --no-startup-id "i3-msg 'focus output left'"
bindsym $leader+Right exec  --no-startup-id "i3-msg 'focus output right'"

## Move container to the next output (and keep focus)
bindsym $leader+Shift+Left exec  --no-startup-id "i3-msg 'move container to output left; focus output left'"
bindsym $leader+Shift+Right exec  --no-startup-id "i3-msg 'move container to output right; focus output right'"

#######################################################
## i3 - Workspaces and all        									 ##
#######################################################

## Modals
set $eggwl sx
set $eggwm cx
set $eggwr dx

bindsym $leader+1 mode $eggwl; exec --no-startup-id "$sk/brightness.sh $dimamount $output_tv_screen $output_sx_screen"
bindsym $leader+2 mode $eggwm; exec --no-startup-id "$sk/brightness.sh $dimamount $output_tv_screen $output_cx_screen"
bindsym $leader+3 mode $eggwr; exec --no-startup-id "$sk/brightness.sh $dimamount $output_tv_screen $output_dx_screen"

## Left Monitor 
workspace $workspace_social	 output $output_sx_screen
workspace $workspace_media	 output $output_sx_screen
workspace $workspace_focusi	 output $output_sx_screen

## Central Monitor
workspace $workspace_termi	 output $output_cx_screen
workspace $workspace_termii	 output $output_cx_screen
workspace $workspace_focusii output $output_cx_screen
workspace $workspace_gaming	 output $output_cx_screen

## Right Monitor
workspace $workspace_nav	 output $output_dx_screen
workspace $workspace_misc	 output $output_dx_screen
workspace $workspace_setup output $output_dx_screen

#######################################################
## i3 - Modals bindings           									 ##
#######################################################

# Left
mode $eggwl {
	bindsym 1 workspace $workspace_social; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym 2 workspace $workspace_media; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym 3 workspace $workspace_focusi; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"

	bindsym $leader+1 workspace $workspace_social; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym $leader+2 workspace $workspace_media; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym $leader+3 workspace $workspace_focusi; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"

	bindsym Shift+1 move container to workspace $workspace_social; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym Shift+2 move container to workspace $workspace_media; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym Shift+3 move container to workspace $workspace_focus; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"

	bindsym $leader+Shift+1 move container to workspace $workspace_social; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym $leader+Shift+2 move container to workspace $workspace_media; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym $leader+Shift+3 move container to workspace $workspace_focusi; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	# Exit
	bindsym Escape mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
}

# Center 
mode $eggwm {
	bindsym 1 workspace $workspace_termi; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym 2 workspace $workspace_termii; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym 3 workspace $workspace_focusii; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym 4 workspace $workspace_gaming; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"

	bindsym $leader+1 workspace $workspace_termi; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym $leader+2 workspace $workspace_termii; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym $leader+3 workspace $workspace_focusii; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym $leader+4 workspace $workspace_gaming; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"

	bindsym Shift+1 move container to workspace $workspace_termi; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym Shift+2 move container to workspace $workspace_termii; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym Shift+3 move container to workspace $workspace_focusii; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym Shift+4 move container to workspace $workspace_gaming; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	
	bindsym $leader+Shift+1 move container to workspace $workspace_termi; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym $leader+Shift+2 move container to workspace $workspace_termii; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym $leader+Shift+3 move container to workspace $workspace_focusii; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym $leader+Shift+4 move container to workspace $workspace_gaming; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"

	# Exit
	bindsym Escape mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
}


# Right 
mode $eggwr {
	bindsym 1 workspace $workspace_nav; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym 2 workspace $workspace_misc; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym 3 workspace $workspace_setup; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"

	bindsym $leader+1 workspace $workspace_nav; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym $leader+2 workspace $workspace_misc; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym $leader+3 workspace $workspace_setup; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"

	bindsym Shift+1 move container to workspace $workspace_nav; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym Shift+2 move container to workspace $workspace_misc; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym Shift+3 move container to workspace $workspace_setup; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	
	bindsym $leader+Shift+1 move container to workspace $workspace_nav; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym $leader+Shift+2 move container to workspace $workspace_misc; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
	bindsym $leader+Shift+3 move container to workspace $workspace_setup; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"

	# Exit
	bindsym Escape mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $output_tv_screen"
}

#######################################################
## i3 - Specific hooks           										 ##
#######################################################
set $bgimage $HOME/.config/i3/imgs/space3240.jpg
exec_always --no-startup-id xwallpaper --no-randr --tile $bgimage
