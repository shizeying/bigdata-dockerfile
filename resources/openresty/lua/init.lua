local http = require "resty.http"
local cjson = require "cjson"
-- 通过API获取负载平衡信息
local upstream_url = "http://127.0.0.1:8081/get_upstream"
local method_ = "GET"

-- 更新间隔
local delay = 2
local new_timer = ngx.timer.every

-- 轮询逻辑
local update = function(premature)
    if not premature then
        local httpc = http:new()
        local resp, err = httpc:request_uri(upstream_url, {
            method = method_,
            })
        if not resp then
            ngx.log(ngx.ERR, "get upstream err:", err)
        else
            ngx.shared._upstream:set("_upstream", resp.body)
        end
    end
end

if 0 == ngx.worker.id() then
    local ok, err = new_timer(delay, update)
    if not ok then
        ngx.log(ngx.ERR, "create timer err:", err)
        return
    end
end