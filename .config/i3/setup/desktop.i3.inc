#######################################################
## i3 - Desktop specific settings										 ##
#######################################################

## Monitors 
set_from_resource $left					de.monitor.left		DVI-I-1
set_from_resource $main					de.monitor.main		DVI-I-1
set_from_resource $right				de.monitor.right	DVI-I-1
set_from_resource $tv						de.monitor.tv			DVI-I-1

## Dim amount
set_from_resource $dimamount		de.monitor.dim		0.35
set_from_resource $gap-outer		i3.gap.outer			0

#######################################################
## i3 - Specific bindings        										 ##
#######################################################

## Move to the next output
bindsym $leader+Left exec --no-startup-id "i3-msg 'focus output left'"
bindsym $leader+Right exec  --no-startup-id "i3-msg 'focus output right'"

## Move container to the next output (and keep focus)
bindsym $leader+$shift+Left exec  --no-startup-id "i3-msg 'move container to output left; focus output left'"
bindsym $leader+$shift+Right exec  --no-startup-id "i3-msg 'move container to output right; focus output right'"

#######################################################
## i3 - Workspaces and all        									 ##
#######################################################

## Modals
set_from_resource $eggwl i3.workspace-left		"       MI"
set_from_resource $eggwm i3.workspace-main		"      MII"
set_from_resource $eggwr i3.workspace-right		"     MIII"

bindsym $leader+1 mode $eggwl; exec --no-startup-id "$sk/brightness.sh $dimamount $tv $left"
bindsym $leader+2 mode $eggwm; exec --no-startup-id "$sk/brightness.sh $dimamount $tv $main"
bindsym $leader+3 mode $eggwr; exec --no-startup-id "$sk/brightness.sh $dimamount $tv $right"

## Left Monitor 
set_from_resource $wsl1 i3.workspace-social		"  Unk   I"
set_from_resource $wsl2 i3.workspace-media		"  Unk  II"
set_from_resource $wsl3 i3.workspace-focusi		"  Unk III"

workspace $wsl1 output $left
workspace $wsl2 output $left
workspace $wsl3 output $left

assign [class="TelegramDesktop"] $wsl1
for_window [class="firefox" title="^WhatsApp — Mozilla Firefox$"] move to workspace $wsl1
assign [class="discord"] $wsl2

# Set gaps
set_from_resource $top-gap-l		i3.workspacegap.left.top		$gap-outer
workspace $wsl1 gaps top $top-gap-l
workspace $wsl2 gaps top $top-gap-l
workspace $wsl3 gaps top $top-gap-l

set_from_resource $bottom-gap-l i3.workspacegap.left.bottom	0
workspace $wsl1 gaps bottom $bottom-gap-l
workspace $wsl2 gaps bottom $bottom-gap-l
workspace $wsl3 gaps bottom $bottom-gap-l

set_from_resource $left-gap-l		i3.workspacegap.left.left		0
workspace $wsl1 gaps left $left-gap-l
workspace $wsl2 gaps left $left-gap-l
workspace $wsl3 gaps left $left-gap-l

set_from_resource $right-gap-l	i3.workspacegap.left.right		0
workspace $wsl1 gaps right $right-gap-l
workspace $wsl2 gaps right $right-gap-l
workspace $wsl3 gaps right $right-gap-l

## Central Monitor
set_from_resource $wsm1 i3.workspace-termi		"  Unk  IV"
set_from_resource $wsm2 i3.workspace-termii		"  Unk   V"
set_from_resource $wsm3 i3.workspace-focusii	"  Unk  VI"
set_from_resource $wsm4 i3.workspace-gaming		"  Unk VII"

workspace $wsm1 output $main
workspace $wsm2 output $main
workspace $wsm3 output $main
workspace $wsm4 output $main

# Set gaps
set_from_resource $top-gap-m		i3.workspacegap.main.top			0
workspace $wsm1 gaps top $top-gap-m
workspace $wsm2 gaps top $top-gap-m
workspace $wsm3 gaps top $top-gap-m
workspace $wsm4 gaps top $top-gap-m

set_from_resource $bottom-gap-m i3.workspacegap.main.bottom	0
workspace $wsm1 gaps bottom $bottom-gap-m
workspace $wsm2 gaps bottom $bottom-gap-m
workspace $wsm2 gaps bottom $bottom-gap-m
workspace $wsm4 gaps bottom $bottom-gap-m

set_from_resource $left-gap-m		i3.workspacegap.main.left		0
workspace $wsm1 gaps left $left-gap-m
workspace $wsm2 gaps left $left-gap-m
workspace $wsm3 gaps left $left-gap-m
workspace $wsm4 gaps left $left-gap-m

set_from_resource $right-gap-m	i3.workspacegap.main.right		0
workspace $wsm1 gaps right $right-gap-m
workspace $wsm2 gaps right $right-gap-m
workspace $wsm3 gaps right $right-gap-m
workspace $wsm4 gaps right $right-gap-m

assign [class="gzdoom"] $wsm4

## Right Monitor
set_from_resource $wsr1 i3.workspace-nav  		"  UnkVIII"
set_from_resource $wsr2 i3.workspace-misc  		"  Unk	 IX"
set_from_resource $wsr3 i3.workspace-setup  	"  Unk   X"

workspace $wsr1 output $right
workspace $wsr2 output $right
workspace $wsr3 output $right

# Set gaps
set_from_resource $top-gap-r		i3.workspacegap.right.top			0
workspace $wsr1 gaps top $top-gap-r
workspace $wsr2 gaps top $top-gap-r
workspace $wsr3 gaps top $top-gap-r

set_from_resource $bottom-gap-r i3.workspacegap.right.bottom		0
workspace $wsr1 gaps bottom $bottom-gap-r
workspace $wsr2 gaps bottom $bottom-gap-r
workspace $wsr3 gaps bottom $bottom-gap-r

set_from_resource $left-gap-r		i3.workspacegap.right.left				0
workspace $wsr1 gaps left $left-gap-r
workspace $wsr2 gaps left $left-gap-r
workspace $wsr3 gaps left $left-gap-r

set_from_resource $right-gap-r	i3.workspacegap.right.right		0
workspace $wsr1 gaps right $right-gap-r
workspace $wsr2 gaps right $right-gap-r
workspace $wsr3 gaps right $right-gap-r

#######################################################
## i3 - Modals bindings           									 ##
#######################################################

# Left
mode $eggwl {
	bindsym 1 workspace $wsl1; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym 2 workspace $wsl2; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym 3 workspace $wsl3; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"

	bindsym $leader+1 workspace $wsl1; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $leader+2 workspace $wsl2; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $leader+3 workspace $wsl3; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"

	bindsym $shift+1 move container to workspace $wsl1; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $shift+2 move container to workspace $wsl2; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $shift+3 move container to workspace $wsl3; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"

	bindsym $leader+$shift+1 move container to workspace $wsl1; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $leader+$shift+2 move container to workspace $wsl2; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $leader+$shift+3 move container to workspace $wsl3; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	# Exit
	bindsym $esc mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
}

# Center 
mode $eggwm {
	bindsym 1 workspace $wsm1; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym 2 workspace $wsm2; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym 3 workspace $wsm3; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym 4 workspace $wsm4; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"

	bindsym $leader+1 workspace $wsm1; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $leader+2 workspace $wsm2; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $leader+3 workspace $wsm3; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $leader+4 workspace $wsm4; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"

	bindsym $shift+1 move container to workspace $wsm1; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $shift+2 move container to workspace $wsm2; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $shift+3 move container to workspace $wsm3; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $shift+4 move container to workspace $wsm4; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	
	bindsym $leader+$shift+1 move container to workspace $wsm1; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $leader+$shift+2 move container to workspace $wsm2; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $leader+$shift+3 move container to workspace $wsm3; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $leader+$shift+4 move container to workspace $wsm4; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"

	# Exit
	bindsym $esc mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
}


# Right 
mode $eggwr {
	bindsym 1 workspace $wsr1; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym 2 workspace $wsr2; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym 3 workspace $wsr3; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"

	bindsym $leader+1 workspace $wsr1; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $leader+2 workspace $wsr2; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $leader+3 workspace $wsr3; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"

	bindsym $shift+1 move container to workspace $wsr1; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $shift+2 move container to workspace $wsr2; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $shift+3 move container to workspace $wsr3; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	
	bindsym $leader+$shift+1 move container to workspace $wsr1; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $leader+$shift+2 move container to workspace $wsr2; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	bindsym $leader+$shift+3 move container to workspace $wsr3; mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
	# Exit
	bindsym $esc mode "default"; exec --no-startup-id "$sk/brightness.sh 1 $tv"
}
