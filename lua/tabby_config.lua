-- Tabby 탭 관리 및 버퍼 네비게이션 설정

local M = {}

-- 탭별 버퍼 관리 헬퍼 함수
function M.list_tab_buffers()
	-- 현재 탭의 모든 버퍼 목록 표시
	local wins = vim.api.nvim_tabpage_list_wins(0)
	local buffers = {}
	local seen = {}
	
	for _, win in ipairs(wins) do
		local buf = vim.api.nvim_win_get_buf(win)
		if not seen[buf] and vim.api.nvim_buf_is_valid(buf) 
			and vim.bo[buf].buflisted then
			seen[buf] = true
			local name = vim.api.nvim_buf_get_name(buf)
			if name == "" then
				name = "[No Name]"
			else
				name = vim.fn.fnamemodify(name, ":t")
			end
			table.insert(buffers, string.format("%d: %s", buf, name))
		end
	end
	
	if #buffers == 0 then
		print("현재 탭에 열린 버퍼가 없습니다")
	else
		print("현재 탭의 버퍼:")
		for _, buf_info in ipairs(buffers) do
			print("  " .. buf_info)
		end
	end
end

-- 탭 정보 표시
function M.tab_info()
	local current_tab = vim.api.nvim_get_current_tabpage()
	local tabs = vim.api.nvim_list_tabpages()
	
	print(string.format("탭 %d/%d", 
		vim.fn.index(tabs, current_tab) + 1, #tabs))
	print("")
	M.list_tab_buffers()
end

-- 탭에서 새 버퍼 열기
function M.tab_new_buffer()
	-- 현재 탭에서 새 버퍼 생성
	vim.cmd("enew")
end

-- 탭 간 버퍼 이동
function M.move_buffer_to_tab(target_tab)
	local buf = vim.api.nvim_get_current_buf()
	local buf_name = vim.api.nvim_buf_get_name(buf)
	
	-- 대상 탭으로 전환
	vim.cmd("tabn " .. target_tab)
	-- 버퍼 열기
	if buf_name ~= "" then
		vim.cmd("e " .. buf_name)
	else
		vim.cmd("b " .. buf)
	end
end

-- 명령어 등록
vim.api.nvim_create_user_command("TabInfo", function()
	M.tab_info()
end, { desc = "현재 탭 정보 표시" })

vim.api.nvim_create_user_command("TabBuffers", function()
	M.list_tab_buffers()
end, { desc = "현재 탭의 버퍼 목록" })

vim.api.nvim_create_user_command("TabNewBuffer", function()
	M.tab_new_buffer()
end, { desc = "현재 탭에 새 버퍼" })

vim.api.nvim_create_user_command("MoveBufferToTab", function(opts)
	local target = tonumber(opts.args)
	if target then
		M.move_buffer_to_tab(target)
	else
		print("사용법: :MoveBufferToTab <탭번호>")
	end
end, { 
	nargs = 1,
	desc = "버퍼를 다른 탭으로 이동" 
})

-- 키맵핑 추가 (선택사항)
-- 탭 내 버퍼 전환 (기존 ,h ,l과 별도로)
vim.keymap.set("n", "<Leader>tb", ":TabBuffers<CR>", 
	{ desc = "현재 탭 버퍼 목록" })
vim.keymap.set("n", "<Leader>ti", ":TabInfo<CR>", 
	{ desc = "탭 정보 표시" })

return M