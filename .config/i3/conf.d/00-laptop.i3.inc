#######################################################
## i3 - Specific hooks           										 ##
#######################################################
set $bgimage $HOME/.config/i3/imgs/space1080.jpg
exec_always --no-startup-id xwallpaper --no-randr --tile $bgimage
set $output eDP-1

workspace $workspace_termi output $output
workspace $workspace_nav output $output
workspace $workspace_social output $output 
workspace $workspace_media output $output  
workspace $workspace_termii output $output 
workspace $workspace_focusi output $output 
workspace $workspace_focusii output $output
workspace $workspace_misc output $output   
workspace $workspace_setup output $output
workspace $workspace_gaming output $output

bindsym $leader+1 workspace $workspace_termi
bindsym $leader+2 workspace $workspace_nav
bindsym $leader+3 workspace $workspace_social
bindsym $leader+4 workspace $workspace_media
bindsym $leader+5 workspace $workspace_termii
bindsym $leader+6 workspace $workspace_focusi
bindsym $leader+7 workspace $workspace_focusii
bindsym $leader+8 workspace $workspace_misc
bindsym $leader+9 workspace $workspace_setup
bindsym $leader+0 workspace $workspace_gaming

bindsym $leader+Shift+1 move container to workspace $workspace_termi
bindsym $leader+Shift+2 move container to workspace $workspace_nav
bindsym $leader+Shift+3 move container to workspace $workspace_social
bindsym $leader+Shift+4 move container to workspace $workspace_media
bindsym $leader+Shift+5 move container to workspace $workspace_termii
bindsym $leader+Shift+6 move container to workspace $workspace_focusi
bindsym $leader+Shift+7 move container to workspace $workspace_focusii
bindsym $leader+Shift+8 move container to workspace $workspace_misc
bindsym $leader+Shift+9 move container to workspace $workspace_setup
bindsym $leader+Shift+0 move container to workspace $workspace_gaming
