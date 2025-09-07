-- Neovim 초기화 파일

-- Winbar는 tab_buffer_isolation.lua에서 전담 관리
-- (전역 winbar autocmd 제거로 탭별 독립성 확보)

-- 기본 설정
require("settings")

-- 키 매핑
require("keymaps")

-- 플러그인 관리자 (lazy.nvim) 설정
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- 플러그인 로드
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	defaults = {
		lazy = false,
		version = false,
	},
	install = { colorscheme = { "solarized" } },
	checker = { enabled = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

-- 레거시 핫픽스 시스템 완전 제거됨
-- 이제 bufferline.nvim으로 전면 교체