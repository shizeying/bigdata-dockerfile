local b = require "ngx.balancer"
local md5 = require 'md5'
local cjson = require "cjson"
local resty_roundrobin = require "resty.roundrobin"

function server_data_update()
    local data = ngx.shared._upstream:get("_upstream")
    local upstream_data = cjson.decode(data)
    if not upstream_data then
        ngx.log(ngx.ERR, "cjson.decode err:", err)
        return
    end
    local message = upstream_data["message"]
    if not message then
        ngx.log(ngx.ERR, "message data not found, data:", data)
        return
    end

    local md5_new = md5.sumhexa(data)
    local md5_old = package.loaded.upstream_md5
    -- md5不同,数据有更新
    if md5_old == md5_new then
        ngx.log(ngx.INFO, "md5 sum upstream not update")
        return
    end
    ngx.log(ngx.INFO, "md5 not sum old:", md5_old, "===> new:",md5_new, " data:", data)

    package.loaded.upstream_md5 = md5_new
    local server_list = {}
    for k, v in pairs(message) do
        server_list[v["addr"]] = v["weight"]
    end
    package.loaded.upstream = resty_roundrobin:new(server_list)
end

server_data_update()
local upstream = package.loaded.upstream
local server = upstream:find()
assert(b.set_current_peer(server))