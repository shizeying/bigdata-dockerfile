-- save_config.lua

local _M = {
	file_name = "./nginx-projects/lua/config.lua"
}

function _M.save_server(host, port, weight)

	local file = io.open(_M.file_name, "r+")
	if file == nil then
		return false
	end

	local buffer = file:read("*a")

	local find_begin, find_end = string.find(buffer, 'servers = {')
	if find_begin == nil then
		file:close()
		return false
	end

	file:seek("set", find_end)

	local end_buff = file:read("*a")

	file:seek("set", find_end)

	local new_server = "\n\t\t\t\t" .. "{host ='" .. host .. "', port =" .. tostring(port) ..
			", weight=" .. tostring(weight) .. ", max_fails=3, fail_timeout=10 }" .. "," .. end_buff

	file:write(new_server)

	file:close()

	ngx.say("save server info ok")
	return true
end

function _M.delete_server(port)

	local file = io.open(_M.file_name, "r")
	if file == nil then
		return false
	end

	local buffer = file:read("*a")

	local find_begin, find_end = string.find(buffer, '\t\t\t\t{.-' .. tostring(port) .. '.-},')
	if find_begin == nil then
		file:close()
		return false
	end
	ngx.say("find:", find_begin, "--", find_end)

	file:seek("set")

	local begin_buffer = file:read(find_begin)

	file:seek("set", find_end)

	local end_buff = file:read("*a")

	file:close()

	file = io.open(_M.file_name, "w")
	if file == nil then
		return false
	end

	file:write(begin_buffer .. end_buff)

	file:close()

	ngx.say("delete server info ok")
	return true

end

return _M