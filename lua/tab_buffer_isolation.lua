-- 탭별 버퍼 독립성 구현
-- 각 탭이 독립적인 버퍼 세트를 가지도록 보장

local M = {}
local safe_api = require("safe_api")

-- 디버그 모드
M.debug = false
M.processing = false  -- 재귀 방지 플래그

-- 디버그 출력
local function debug_print(msg)
	if M.debug then
		print("[TabBuffer] " .. msg)
	end
end

-- 재귀 방지 wrapper
local function with_processing_guard(func)
	return function(...)
		if M.processing then
			return
		end
		M.processing = true
		local ok, result = pcall(func, ...)
		M.processing = false
		if not ok then
			debug_print("Error: " .. result)
		end
		return result
	end
end

-- 탭별 버퍼 리스트 초기화
local function init_tab_buffers()
	if not vim.t.tab_buffers then
		vim.t.tab_buffers = {}
		vim.t.tab_current_index = 1
		debug_print("탭 버퍼 리스트 초기화")
	end
end

-- 버퍼가 유효한지 확인
local function is_valid_buffer(bufnr)
	return vim.api.nvim_buf_is_valid(bufnr) 
		and vim.bo[bufnr].buflisted 
		and vim.fn.bufname(bufnr) ~= ""
end

-- 현재 탭에 버퍼 추가
local function add_buffer_to_tab_impl(bufnr)
	init_tab_buffers()
	
	-- nil 체크 추가
	if not bufnr or type(bufnr) ~= "number" then
		return
	end
	
	if not is_valid_buffer(bufnr) then
		return
	end
	
	-- 이미 있으면 추가하지 않음
	for _, b in ipairs(vim.t.tab_buffers) do
		if b == bufnr then
			debug_print("버퍼 " .. bufnr .. " 이미 존재")
			return
		end
	end
	
	table.insert(vim.t.tab_buffers, bufnr)
	debug_print("버퍼 " .. bufnr .. " 추가됨. 현재 목록: " .. vim.inspect(vim.t.tab_buffers))
	
	-- Winbar 업데이트 (재귀 방지)
	if _G.WinbarBuffersModule and not M.processing then
		vim.schedule(function()
			_G.WinbarBuffersModule.update_winbar()
		end)
	end
end

M.add_buffer_to_tab = with_processing_guard(add_buffer_to_tab_impl)

-- 현재 탭에서 버퍼 제거
local function remove_buffer_from_tab_impl(bufnr)
	init_tab_buffers()
	
	for i, b in ipairs(vim.t.tab_buffers) do
		if b == bufnr then
			table.remove(vim.t.tab_buffers, i)
			debug_print("버퍼 " .. bufnr .. " 제거됨")
			
			-- 현재 인덱스 조정
			if vim.t.tab_current_index > #vim.t.tab_buffers then
				vim.t.tab_current_index = #vim.t.tab_buffers
			end
			if vim.t.tab_current_index < 1 and #vim.t.tab_buffers > 0 then
				vim.t.tab_current_index = 1
			end
			break
		end
	end
	
	-- Winbar 업데이트 (재귀 방지)
	if _G.WinbarBuffersModule and not M.processing then
		vim.schedule(function()
			_G.WinbarBuffersModule.update_winbar()
		end)
	end
end

M.remove_buffer_from_tab = with_processing_guard(remove_buffer_from_tab_impl)

-- 현재 탭의 버퍼 리스트 정리 (유효하지 않은 버퍼 제거)
function M.cleanup_tab_buffers()
	init_tab_buffers()
	
	local valid_buffers = {}
	for _, bufnr in ipairs(vim.t.tab_buffers) do
		if is_valid_buffer(bufnr) then
			table.insert(valid_buffers, bufnr)
		else
			debug_print("유효하지 않은 버퍼 " .. bufnr .. " 제거")
		end
	end
	
	vim.t.tab_buffers = valid_buffers
end

-- 현재 버퍼의 탭 인덱스 찾기
function M.find_current_buffer_index()
	init_tab_buffers()
	local current_buf = vim.api.nvim_get_current_buf()
	
	for i, bufnr in ipairs(vim.t.tab_buffers) do
		if bufnr == current_buf then
			vim.t.tab_current_index = i
			return i
		end
	end
	
	-- 현재 버퍼가 리스트에 없으면 추가
	M.add_buffer_to_tab(current_buf)
	vim.t.tab_current_index = #vim.t.tab_buffers
	return vim.t.tab_current_index
end

-- 탭 로컬 다음 버퍼로 이동
function M.tab_local_bnext()
	init_tab_buffers()
	M.cleanup_tab_buffers()
	
	if #vim.t.tab_buffers == 0 then
		print("현재 탭에 버퍼가 없습니다")
		return
	end
	
	-- 현재 위치 찾기
	M.find_current_buffer_index()
	
	-- 다음 버퍼로 이동
	vim.t.tab_current_index = vim.t.tab_current_index + 1
	if vim.t.tab_current_index > #vim.t.tab_buffers then
		vim.t.tab_current_index = 1
	end
	
	local next_buf = vim.t.tab_buffers[vim.t.tab_current_index]
	if next_buf and is_valid_buffer(next_buf) then
		-- 안전한 버퍼 전환
		local ok, err = safe_api.safe_buffer_switch(next_buf)
		if not ok then
			debug_print("버퍼 전환 실패: " .. (err or "알 수 없는 오류"))
		end
		debug_print("버퍼 " .. next_buf .. "로 이동 (인덱스: " .. vim.t.tab_current_index .. ")")
	end
end

-- 탭 로컬 이전 버퍼로 이동
function M.tab_local_bprev()
	init_tab_buffers()
	M.cleanup_tab_buffers()
	
	if #vim.t.tab_buffers == 0 then
		print("현재 탭에 버퍼가 없습니다")
		return
	end
	
	-- 현재 위치 찾기
	M.find_current_buffer_index()
	
	-- 이전 버퍼로 이동
	vim.t.tab_current_index = vim.t.tab_current_index - 1
	if vim.t.tab_current_index < 1 then
		vim.t.tab_current_index = #vim.t.tab_buffers
	end
	
	local prev_buf = vim.t.tab_buffers[vim.t.tab_current_index]
	if prev_buf and is_valid_buffer(prev_buf) then
		-- 안전한 버퍼 전환
		local ok, err = safe_api.safe_buffer_switch(prev_buf)
		if not ok then
			debug_print("버퍼 전환 실패: " .. (err or "알 수 없는 오류"))
		end
		debug_print("버퍼 " .. prev_buf .. "로 이동 (인덱스: " .. vim.t.tab_current_index .. ")")
	end
end

-- 탭 로컬 버퍼 삭제
function M.tab_local_bdelete()
	local current_buf = vim.api.nvim_get_current_buf()
	
	-- 다음 버퍼로 먼저 이동
	M.tab_local_bnext()
	
	-- 현재 버퍼가 변경되었다면 이전 버퍼 삭제
	if vim.api.nvim_get_current_buf() ~= current_buf then
		local ok = safe_api.safe_buffer_delete(current_buf)
		if ok then
			M.remove_buffer_from_tab(current_buf)
		else
			debug_print("버퍼 삭제 실패: " .. current_buf)
		end
	else
		-- 마지막 버퍼인 경우
		safe_api.safe_cmd("enew")
		local ok = safe_api.safe_buffer_delete(current_buf)
		if ok then
			M.remove_buffer_from_tab(current_buf)
		end
		M.remove_buffer_from_tab(current_buf)
	end
end

-- 현재 탭의 버퍼 목록 출력 (디버그용)
function M.list_tab_buffers()
	init_tab_buffers()
	M.cleanup_tab_buffers()
	
	if #vim.t.tab_buffers == 0 then
		print("현재 탭에 버퍼가 없습니다")
		return
	end
	
	print("=== 탭 " .. vim.api.nvim_get_current_tabpage() .. " 버퍼 목록 ===")
	for i, bufnr in ipairs(vim.t.tab_buffers) do
		local name = vim.fn.bufname(bufnr)
		if name == "" then name = "[No Name]" end
		local current = (bufnr == vim.api.nvim_get_current_buf()) and " (현재)" or ""
		print(string.format("%d. [%d] %s%s", i, bufnr, name, current))
	end
end

-- 디버그 모드 토글
function M.toggle_debug()
	M.debug = not M.debug
	print("TabBuffer 디버그 모드: " .. (M.debug and "ON" or "OFF"))
end

-- 설정 초기화
function M.setup()
	-- 전역 참조 (winbar에서 사용)
	_G.TabBufferIsolation = M
	
	-- Autocmd 그룹
	local group = vim.api.nvim_create_augroup("TabBufferIsolation", { clear = true })
	
	-- 새 버퍼 진입 시 현재 탭에 추가 - 더 안전한 조건
	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = group,
		callback = function(args)
			-- 재귀 방지 및 특수 버퍼 제외
			if M.processing then return end
			
			local ft = vim.bo[args.buf].filetype
			local exclude_ft = {
				"NvimTree", "nvim-tree", "neo-tree",
				"help", "dashboard", "alpha",
				"fzf", "telescope", "TelescopePrompt",
				"qf", "quickfix"
			}
			
			if not vim.tbl_contains(exclude_ft, ft) then
				vim.schedule(function()
					M.add_buffer_to_tab(args.buf)
				end)
			end
		end,
	})
	
	-- 버퍼 삭제 시 탭에서 제거 - 단순화
	vim.api.nvim_create_autocmd("BufDelete", {
		group = group,
		callback = function(args)
			if M.processing then return end
			vim.schedule(function()
				M.remove_buffer_from_tab(args.buf)
			end)
		end,
	})
	
	-- 탭 진입 시 초기화
	vim.api.nvim_create_autocmd("TabEnter", {
		group = group,
		callback = function()
			if M.processing then return end
			vim.schedule(function()
				init_tab_buffers()
				M.cleanup_tab_buffers()
				debug_print("탭 진입. 버퍼 목록: " .. vim.inspect(vim.t.tab_buffers or {}))
			end)
		end,
	})
	
	-- 새 탭 생성 시 현재 버퍼만 추가
	vim.api.nvim_create_autocmd("TabNew", {
		group = group,
		callback = function()
			if M.processing then return end
			vim.schedule(function()
				init_tab_buffers()
				local current_buf = vim.api.nvim_get_current_buf()
				if is_valid_buffer(current_buf) then
					M.add_buffer_to_tab(current_buf)
				end
			end)
		end,
	})
	
	-- 명령어 등록
	vim.api.nvim_create_user_command("TabBufferList", function()
		M.list_tab_buffers()
	end, { desc = "현재 탭의 버퍼 목록 표시" })
	
	vim.api.nvim_create_user_command("TabBufferDebug", function()
		M.toggle_debug()
	end, { desc = "TabBuffer 디버그 모드 토글" })
	
	vim.api.nvim_create_user_command("TabBufferCleanup", function()
		M.cleanup_tab_buffers()
		print("탭 버퍼 목록 정리 완료")
	end, { desc = "탭 버퍼 목록 정리" })
	
	-- 초기화
	vim.schedule(function()
		init_tab_buffers()
		print("✅ 탭별 버퍼 독립성 활성화됨")
	end)
end

return M