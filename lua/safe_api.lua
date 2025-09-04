-- 안전한 API 호출 래퍼 모듈
-- 모든 위험한 작업을 안전하게 처리

local M = {}

-- 안전한 버퍼 전환
function M.safe_buffer_switch(bufnr)
	if not bufnr or type(bufnr) ~= "number" then
		return false, "Invalid buffer number"
	end
	
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false, "Buffer " .. bufnr .. " is not valid"
	end
	
	local ok, err = pcall(vim.cmd, "buffer " .. bufnr)
	if not ok then
		return false, "Failed to switch to buffer " .. bufnr .. ": " .. tostring(err)
	end
	
	return true
end

-- 안전한 버퍼 삭제
function M.safe_buffer_delete(bufnr)
	if not bufnr or type(bufnr) ~= "number" then
		return false, "Invalid buffer number"
	end
	
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false, "Buffer " .. bufnr .. " is not valid"
	end
	
	local ok, err = pcall(vim.cmd, "bdelete " .. bufnr)
	if not ok then
		return false, "Failed to delete buffer " .. bufnr .. ": " .. tostring(err)
	end
	
	return true
end

-- 안전한 vim.t 접근
function M.safe_tab_var_get(key, default)
	if not vim.t then
		return default
	end
	
	local value = vim.t[key]
	if value == nil then
		return default
	end
	
	return value
end

-- 안전한 vim.t 설정
function M.safe_tab_var_set(key, value)
	if not vim.t then
		return false, "Tab-local variables not available"
	end
	
	local ok, err = pcall(function()
		vim.t[key] = value
	end)
	
	if not ok then
		return false, "Failed to set tab variable: " .. tostring(err)
	end
	
	return true
end

-- 안전한 명령 실행
function M.safe_cmd(command)
	if not command or type(command) ~= "string" then
		return false, "Invalid command"
	end
	
	local ok, err = pcall(vim.cmd, command)
	if not ok then
		return false, "Command failed: " .. tostring(err)
	end
	
	return true
end

-- 안전한 함수 호출
function M.safe_fn_call(fn_name, ...)
	if not fn_name or type(fn_name) ~= "string" then
		return false, nil, "Invalid function name"
	end
	
	if not vim.fn[fn_name] then
		return false, nil, "Function " .. fn_name .. " does not exist"
	end
	
	local ok, result = pcall(vim.fn[fn_name], ...)
	if not ok then
		return false, nil, "Function call failed: " .. tostring(result)
	end
	
	return true, result
end

-- API 존재 여부 체크
function M.api_exists(api_name)
	if not api_name or type(api_name) ~= "string" then
		return false
	end
	
	-- vim.api 테이블에서 함수 검색
	local parts = vim.split(api_name, ".", { plain = true })
	local current = vim
	
	for _, part in ipairs(parts) do
		if not current[part] then
			return false
		end
		current = current[part]
	end
	
	return type(current) == "function"
end

-- 버그 리포트 생성
function M.report_error(context, error_msg)
	local timestamp = os.date("%Y-%m-%d %H:%M:%S")
	local report = string.format("[%s] %s: %s", timestamp, context, error_msg)
	
	-- 에러 로그 파일에 기록
	local log_file = vim.fn.stdpath("data") .. "/nvim_error.log"
	local file = io.open(log_file, "a")
	if file then
		file:write(report .. "\n")
		file:close()
	end
	
	-- 디버그 모드에서만 화면에 출력
	if vim.g.safe_api_debug then
		vim.notify(report, vim.log.levels.ERROR)
	end
end

-- 초기화 체크
function M.validate_nvim_version()
	local version = vim.version()
	if version.major < 0 or (version.major == 0 and version.minor < 9) then
		return false, "Neovim 0.9.0 이상이 필요합니다"
	end
	return true
end

-- 필수 API 체크
function M.check_required_apis()
	local required_apis = {
		"api.nvim_buf_is_valid",
		"api.nvim_get_current_buf",
		"api.nvim_buf_get_name",
		"api.nvim_create_autocmd",
		"api.nvim_create_augroup",
		"api.nvim_set_hl",
		"api.nvim_create_user_command",
	}
	
	local missing = {}
	for _, api in ipairs(required_apis) do
		if not M.api_exists(api) then
			table.insert(missing, api)
		end
	end
	
	if #missing > 0 then
		return false, "Missing required APIs: " .. table.concat(missing, ", ")
	end
	
	return true
end

-- 설정
function M.setup(opts)
	opts = opts or {}
	
	-- 디버그 모드 설정
	vim.g.safe_api_debug = opts.debug or false
	
	-- Neovim 버전 체크
	local ok, err = M.validate_nvim_version()
	if not ok then
		vim.notify("Safe API: " .. err, vim.log.levels.ERROR)
		return false
	end
	
	-- 필수 API 체크
	ok, err = M.check_required_apis()
	if not ok then
		vim.notify("Safe API: " .. err, vim.log.levels.ERROR)
		return false
	end
	
	return true
end

return M