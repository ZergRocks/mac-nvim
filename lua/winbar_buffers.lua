-- Winbar 버퍼 표시 설정
-- 각 윈도우 상단에 현재 탭의 버퍼 목록 표시

local M = {}
local safe_api = require("safe_api")

M.processing = false  -- 재귀 방지 플래그

-- 현재 탭의 모든 버퍼 가져오기 (tab_buffer_isolation과 동기화)
function M.get_tab_buffers()
	local current_buf = vim.api.nvim_get_current_buf()
	
	-- tab_buffer_isolation의 탭 버퍼 리스트 사용
	if vim.t and vim.t.tab_buffers then
		-- 유효한 버퍼만 필터링
		local valid_buffers = {}
		for _, bufnr in ipairs(vim.t.tab_buffers) do
			if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
				table.insert(valid_buffers, bufnr)
			end
		end
		return valid_buffers, current_buf
	else
		-- 폴백: 탭 버퍼 리스트가 없으면 빈 리스트
		return {}, current_buf
	end
end

-- 버퍼 정보 포맷팅
function M.format_buffer_name(bufnr, index, is_current)
	local name = vim.api.nvim_buf_get_name(bufnr)
	local modified = vim.bo[bufnr].modified
	
	if name == "" then
		name = "[No Name]"
	else
		name = vim.fn.fnamemodify(name, ":t")
	end
	
	-- 인덱스 부분
	local index_part = "%#WinbarNumber#" .. index .. ":%#WinbarNormal#"
	
	-- 파일명 부분
	local name_part = name
	
	-- 수정 표시
	local modified_part = ""
	if modified then
		modified_part = "%#WinbarModified# ●%#WinbarNormal#"
	end
	
	-- 현재 버퍼는 다른 스타일
	if is_current then
		return "%#WinbarCurrent#[" .. index .. ":" .. name .. modified_part .. "]%#WinbarNormal#"
	elseif modified then
		return index_part .. "%#WinbarModified#" .. name_part .. modified_part .. "%#WinbarNormal#"
	else
		return index_part .. name_part
	end
end

-- Winbar 문자열 생성
function M.create_winbar()
	local buffers, current_buf = M.get_tab_buffers()
	local components = {}
	
	if #buffers == 0 then
		return ""
	end
	
	-- 버퍼를 인덱스와 함께 포맷
	for i, bufnr in ipairs(buffers) do
		local is_current = (bufnr == current_buf)
		local formatted = M.format_buffer_name(bufnr, i, is_current)
		
		-- 클릭 가능한 요소로 만들기
		local clickable = string.format("%%@v:lua.WinbarBufferClick(%d)@%s%%X", bufnr, formatted)
		table.insert(components, clickable)
	end
	
	-- 구분자로 연결
	return " " .. table.concat(components, " │ ") .. " "
end

-- 버퍼 클릭 핸들러
function _G.WinbarBufferClick(bufnr)
	-- nil 및 타입 체크
	if not bufnr or type(bufnr) ~= "number" then
		return ""
	end
	
	-- 안전한 버퍼 전환
	local ok, err = safe_api.safe_buffer_switch(bufnr)
	if not ok then
		if M.debug then
			print("버퍼 전환 실패: " .. (err or "알 수 없는 오류"))
		end
	end
	return ""  -- 클릭 핸들러는 빈 문자열 반환
end


-- Winbar 업데이트 (재귀 방지)
function M.update_winbar()
	if M.processing then return end
	
	-- 특정 파일 타입은 제외
	local exclude_ft = {
		"NvimTree", "nvim-tree", "neo-tree",
		"help", "dashboard", "alpha",
		"fzf", "telescope", "TelescopePrompt",
		"qf", "quickfix"
	}
	
	if vim.tbl_contains(exclude_ft, vim.bo.filetype) then
		vim.wo.winbar = ""
		return
	end
	
	M.processing = true
	vim.wo.winbar = M.create_winbar()
	M.processing = false
end

-- 숫자 키로 버퍼 전환 (탭 로컬)
function M.switch_to_buffer(index)
	local buffers = M.get_tab_buffers()
	if buffers[index] then
		-- 안전한 버퍼 전환
		local ok, err = safe_api.safe_buffer_switch(buffers[index])
		if not ok then
			print("버퍼 " .. index .. " 전환 실패: " .. (err or "알 수 없는 오류"))
			return
		end
		-- tab_buffer_isolation의 인덱스도 업데이트
		if vim.t and vim.t.tab_buffers then
			vim.t.tab_current_index = index
		end
	else
		print("버퍼 " .. index .. "가 없습니다")
	end
end

-- 설정 초기화
function M.setup()
	-- 전역 참조 (tab_buffer_isolation에서 사용)
	_G.WinbarBuffersModule = M
	
	-- 색상 설정 로드
	require("winbar_colors").setup()
	
	-- Autocmd 그룹
	local group = vim.api.nvim_create_augroup("WinbarBuffers", { clear = true })
	
	-- 버퍼 진입 시 Winbar 업데이트 - 더 안전하게
	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = group,
		callback = function()
			if M.processing then return end
			vim.schedule(function()
				M.update_winbar()
			end)
		end,
	})
	
	-- Winbar 업데이트 이벤트
	vim.api.nvim_create_autocmd({
		"TabEnter",
		"BufModifiedSet",
		"BufWritePost",
	}, {
		group = group,
		callback = function()
			if M.processing then return end
			vim.schedule(function()
				M.update_winbar()
			end)
		end,
	})
	
	-- 윈도우 진입 시 업데이트
	vim.api.nvim_create_autocmd("WinEnter", {
		group = group,
		callback = function()
			if M.processing then return end
			vim.schedule(function()
				M.update_winbar()
			end)
		end,
	})
	
	-- 숫자 키맵 설정 (,1 ~ ,9)
	for i = 1, 9 do
		vim.keymap.set("n", "<Leader>" .. i, function()
			M.switch_to_buffer(i)
		end, { desc = "버퍼 " .. i .. "로 전환" })
	end
	
	-- 버퍼 목록 새로고침 명령
	vim.api.nvim_create_user_command("WinbarRefresh", function()
		M.update_winbar()
	end, { desc = "Winbar 버퍼 목록 새로고침" })
	
	-- 초기 업데이트
	vim.schedule(function()
		M.update_winbar()
	end)
end

return M