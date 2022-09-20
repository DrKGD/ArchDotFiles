
require('lua.debug').clear()
require('config.notification')
--------------------------------------------
-- Setup plugins and theme                --
--------------------------------------------
require('config.plugin')
require('config.themes.red')

--------------------------------------------
-- Setup keybidings and behaviour         --
--------------------------------------------
require('config.behaviour')
require(('config.profile.%s'):format(os.getenv('PROFILE')))

--------------------------------------------
-- Spawn all daemons                      --
--------------------------------------------
require('config.startup')

--------------------------------------------
-- All done                               --
--------------------------------------------
---@diagnostic disable-next-line: undefined-global
awesome.emit_signal('awesomewm::configuration_done')
