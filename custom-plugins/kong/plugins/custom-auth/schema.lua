-- schema.lua
return {
  no_consumer = true, -- this plugin will only be applied to Services or Routes,
  fields = {
    check_url = {type="string"},
    access_method = {type = "array"}
  },
  self_check = function(schema, plugin_t, dao, is_updating)
    -- 自定义的验证函数
    if table.getn(schema.access_method) <= 0 then
      return false
    end

    kong.log(schema)
    kong.log(plugin_t)
    kong.log(dao)
    kong.log(is_updating)
    local method_array = {"GET", "POST", "PUT", "HEAD", "DELETE", "CONNECT", "OPTIONS", "TRACE"}
    for i in pairs(method_array) do
      for j in pairs(schema.access_method) do
        if method_array[i] == schema.access_method[j] then
          return true
        end
      end
    end
    return false
  end
}
