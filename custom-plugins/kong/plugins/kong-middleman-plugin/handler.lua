local BasePlugin = require "kong.plugins.base_plugin"
local access = require "kong.plugins.kong-middleman-plugin.access"

local MiddlemanHandler = BasePlugin:extend()

MiddlemanHandler.PRIORITY = 900

function MiddlemanHandler:new()
  MiddlemanHandler.super.new(self, "kong-middleman-plugin")
end

function MiddlemanHandler:access(conf)
  MiddlemanHandler.super.access(self)
  access.execute(conf)
end

return MiddlemanHandler