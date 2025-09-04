-- Winbar 버퍼 표시 설정
-- 각 윈도우 상단에 현재 탭의 버퍼 목록 표시

local M = {}

-- 현재 탭의 모든 버퍼 가져오기
function M.get_tab_buffers()
	local buffers = {}
	local current_buf = vim.api.nvim_get_current_buf()
	
	-- 현재 탭의 모든 윈도우에서 버퍼 수집
	local wins = vim.api.nvim_tabpage_list_wins(0)
	local seen = {}
	
	for _, win in ipairs(wins) do
		local buf = vim.api.nvim_win_get_buf(win)
		if not seen[buf] and vim.api.nvim_buf_is_valid(buf) 
			and vim.bo[buf].buflisted then
			seen[buf] = true
			table.insert(buffers, buf)
		end
	end
	
	-- 열려있지 않은 버퍼도 포함 (이전에 열었던 버퍼)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if not seen[buf] and vim.api.nvim_buf_is_valid(buf)
			and vim.bo[buf].buflisted 
			and vim.fn.bufname(buf) ~= "" then
			-- 현재 탭에서 한번이라도 열었던 버퍼인지 확인
			local buf_tabnr = vim.fn.getbufvar(buf, "__last_tab")
			local current_tabnr = vim.api.nvim_get_current_tabpage()
			if buf_tabnr == current_tabnr then
				table.insert(buffers, buf)
			end
		end
	end
	
	return buffers, current_buf
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
	if vim.api.nvim_buf_is_valid(bufnr) then
		vim.cmd("buffer " .. bufnr)
	end
	return ""  -- 클릭 핸들러는 빈 문자열 반환
end

-- 현재 탭 추적
function M.track_buffer_tab()
	local buf = vim.api.nvim_get_current_buf()
	local tab = vim.api.nvim_get_current_tabpage()
	vim.fn.setbufvar(buf, "__last_tab", tab)
end

-- Winbar 업데이트
function M.update_winbar()
	-- 특정 파일 타입은 제외
	local exclude_ft = {
		"NvimTree", "nvim-tree", "neo-tree",
		"help", "dashboard", "alpha",
		"fzf", "telescope", "TelescopePrompt"
	}
	
	if vim.tbl_contains(exclude_ft, vim.bo.filetype) then
		vim.wo.winbar = ""
		return
	end
	
	vim.wo.winbar = M.create_winbar()
end

-- 숫자 키로 버퍼 전환
function M.switch_to_buffer(index)
	local buffers = M.get_tab_buffers()
	if buffers[index] then
		vim.cmd("buffer " .. buffers[index])
	else
		print("버퍼 " .. index .. "가 없습니다")
	end
end

-- 설정 초기화
function M.setup()
	-- 색상 설정 로드
	require("winbar_colors").setup()
	
	-- Autocmd 그룹
	local group = vim.api.nvim_create_augroup("WinbarBuffers", { clear = true })
	
	-- 버퍼 탭 추적
	vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
		group = group,
		callback = function()
			M.track_buffer_tab()
			M.update_winbar()
		end,
	})
	
	-- Winbar 업데이트 이벤트
	vim.api.nvim_create_autocmd({
		"TabEnter",
		"BufModifiedSet",
		"BufWritePost",
		"BufDelete",
	}, {
		group = group,
		callback = function()
			M.update_winbar()
		end,
	})
	
	-- 윈도우 진입 시 업데이트
	vim.api.nvim_create_autocmd("WinEnter", {
		group = group,
		callback = function()
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
	M.update_winbar()
end

return M