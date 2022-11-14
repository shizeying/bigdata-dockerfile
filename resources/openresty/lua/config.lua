-- config.lua

	_M = {}

	_M.global = {
		checkup_timer_interval = 15,
		default_heartbeat_enable =  true,
		checkup_shd_sync_enable = true,
		shd_config_timer_interval = 1,
	}

	_M.up_http = {
		enable = true,
		typ = "http",
		timeout = 2,
		read_timeout = 15,
		send_timeout = 15,
		cluster = {
			{
				servers = {
					{ host = "127.0.0.1", port = 8081, weight=10, max_fails=3, fail_timeout=10 },
					{ host = "127.0.0.1", port = 8082, weight=11, max_fails=3, fail_timeout=10 },
				}
			},
		},
	}

	return _M