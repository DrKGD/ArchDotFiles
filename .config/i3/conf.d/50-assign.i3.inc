#######################################################
## i3 - Assign specific applications to windows      ##
#######################################################
assign [class="TelegramDesktop"] $workspace_social
for_window [class="firefox" title="^WhatsApp — Mozilla Firefox$"] move to workspace $workspace_social
assign [class="discord"] $workspace_media
assign [class="gzdoom"] $workspace_gaming
assign [class="qBittorrent"] $workspace_setup

