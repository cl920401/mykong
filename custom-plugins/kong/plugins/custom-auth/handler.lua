-- 继承BasePlugin
local BasePlugin = require "kong.plugins.base_plugin"
local access = require "kong.plugins.custom-auth.access"
local CustomAuthHandler = BasePlugin:extend()

-- 插件构造函数
function CustomAuthHandler:new()
  CustomAuthHandler.super.new(self, "custom-auth")
end

function CustomAuthHandler:init_worker()
  CustomAuthHandler.super.init_worker(self)
  -- 在这里实现自定义的逻辑
end

function CustomAuthHandler:certificate(config)
  CustomAuthHandler.super.certificate(self)
  -- 在这里实现自定义的逻辑
end

function CustomAuthHandler:rewrite(config)
  CustomAuthHandler.super.rewrite(self)
  -- 在这里实现自定义的逻辑
end

function CustomAuthHandler:access(config)
  CustomAuthHandler.super.access(self)
  -- 在这里实现自定义的逻辑
  if config.access_method == nil or config.check_url == nil then
    return
  end

  local method = kong.request.get_method()
  for i in pairs(config.access_method) do
    if method == config.access_method[i] then
      access.execute(config)
      return
    end
  end

end

function CustomAuthHandler:header_filter(config)
  CustomAuthHandler.super.header_filter(self)
  -- 在这里实现自定义的逻辑
end

function CustomAuthHandler:body_filter(config)
  CustomAuthHandler.super.body_filter(self)
  -- 在这里实现自定义的逻辑
end

function CustomAuthHandler:log(config)
  CustomAuthHandler.super.log(self)
  -- 在这里实现自定义的逻辑
end

return CustomAuthHandler
