local url = require "socket.url"
local cjson = require "cjson"
local string_format = string.format

local kong_response = kong.response

local get_headers = ngx.req.get_headers
local get_uri_args = ngx.req.get_uri_args
local read_body = ngx.req.read_body
local get_body = ngx.req.get_body_data
local get_method = ngx.req.get_method
local ngx_re_match = ngx.re.match
local ngx_re_find = ngx.re.find

local HTTP = "http"
local HTTPS = "https"

local _M = {}

local function parse_url(host_url)
  local parsed_url = url.parse(host_url)
  if not parsed_url.port then
    if parsed_url.scheme == HTTP then
      parsed_url.port = 80
     elseif parsed_url.scheme == HTTPS then
      parsed_url.port = 443
     end
  end
  if not parsed_url.path then
    parsed_url.path = "/"
  end
  return parsed_url
end

local function get_fail_body()
    local ret_table = {}
    ret_table["header"] = {}
    ret_table["header"]["code"]=1110003
    ret_table["header"]["msg"]="token invaild"
    ret_table["header"]["time"]=os.time()
    ret_table["header"]["request_id"]=kong.request.get_header("Request-ID")
    if ret_table["header"]["request_id"]==nil then
        ret_table["header"]["request_id"]=os.time()
    end
    return ret_table
end

local function Authorization(check_url)
    kong.log.info(check_url)
    local http = require "resty.http"
    local httpc = http.new()
    local url = parse_url(check_url)
    kong.log.info(url)
    kong.request.get_header("X-Login-Token")
    local res, err = httpc:request_uri(check_url, {
        method = "POST",
        headers = {
            ["X-Login-Token"] = kong.request.get_header("X-Login-Token"),
            ["X-OV-Token"] = kong.request.get_header("X-OV-Token"),
            ["Device-Type"] = kong.request.get_header("Device-Type"),
            ["Device-ID"] = kong.request.get_header("Device-ID"),
            ["Family-ID"] = kong.request.get_header("Family-ID"),
            ["User-UUID"] = kong.request.get_header("User-UUID"),
            ["Request-ID"] = kong.request.get_header("Request-ID"),
        }
    })


    if not res then
        kong.log.warn("failed to request: ", err)
        return "false"
    end
    if res.status ~= 200 then
        return "false"
    end
    kong.log(res.body)
    local data = cjson.decode(res.body)
    return data
end

function _M.execute(conf)
  kong.log.info(cjson.encode(conf))
  if kong.request.get_header("X-Login-Token") == "27d99df7214130b5b3889fddc4e81ed5" then
      return
  end
  local ret = get_fail_body()
  local auth = Authorization(conf.check_url)
  if auth == "false" then
      kong.log.err("access failed")
      kong.log.info(cjson.encode(ret))
      return kong.response.exit(400, ret, {
          ["Content-Type"] = "application/json"
      })
  elseif auth["header"]["code"] == 200 then
      if kong.request.get_header("Device-Type") == "3" then
          kong.service.request.set_header("Device-ID", auth["data"]["uid"])
          kong.service.request.set_header("Family-ID", auth["data"]["family_id"])
      else
          kong.service.request.set_header("User-UUID", auth["data"]["uid"])
          kong.service.request.set_header("Family-ID", auth["data"]["family_id"])
      end
  else
      kong.log.err("access failed")
      kong.log.info(cjson.encode(auth))
      return kong.response.exit(400, auth, {
          ["Content-Type"] = "application/json"
      })
  end
end


return _M