-- Winbar 버퍼 표시 색상 설정
-- Solarized Light 테마와 어울리는 색상 정의

local M = {}

function M.setup()
	-- Winbar 색상 정의 (Solarized Light 테마 기반)
	local colors = {
		-- 현재 버퍼 (강조)
		WinbarCurrent = { fg = "#002b36", bg = "#eee8d5", bold = true },
		-- 수정된 버퍼
		WinbarModified = { fg = "#dc322f", bg = "#fdf6e3" },
		-- 일반 버퍼
		WinbarNormal = { fg = "#657b83", bg = "#fdf6e3" },
		-- 버퍼 번호
		WinbarNumber = { fg = "#268bd2", bg = "#fdf6e3" },
		-- 구분자
		WinbarSeparator = { fg = "#93a1a1", bg = "#fdf6e3" },
		-- 배경
		WinbarFill = { fg = "#657b83", bg = "#fdf6e3" },
	}
	
	-- 하이라이트 그룹 설정
	for name, opts in pairs(colors) do
		vim.api.nvim_set_hl(0, name, opts)
	end
	
	-- 기본 Winbar 색상 설정
	vim.api.nvim_set_hl(0, "WinBar", { link = "WinbarFill" })
	vim.api.nvim_set_hl(0, "WinBarNC", { link = "WinbarFill" })
end

return M