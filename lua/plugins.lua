return {
	-- Theme (Solarized Light)
	{
		"ishan9299/nvim-solarized-lua",
		config = function()
			vim.cmd([[colorscheme solarized]])
			vim.o.background = "light"
		end,
	},

	-- VSCode-style Buffer Line with Tab Independence
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function() vim.g.barbar_auto_setup = false end,
		config = function()
			require("barbar").setup({
				-- Enable/disable animations
				animation = true,
				-- Enable/disable auto-hiding the tab bar when there is a single buffer
				auto_hide = false,
				-- Enable/disable current/total tabpages indicator (top right corner)
				tabpages = true,
				-- Enable/disable close button
				closable = true,
				-- Enables/disable clickable tabs
				clickable = true,
				-- Exclude certain filetypes and buffer types from the tabline
				exclude_ft = {'javascript'},
				exclude_name = {'package.json'},
				-- Show every buffer
				hide = {extensions = false, inactive = false},
				-- Enable/disable icons
				icons = {
					buffer_index = false,
					buffer_number = false,
					button = '',
					-- Configure how filetype icons are displayed
					filetype = {
						enabled = true,
					},
					separator = {left = '▎', right = ''},
					modified = {button = '●'},
					pinned = {button = '車', filename = true},
					preset = 'default',
				},
				-- If true, new buffers will be inserted at the start/end of the list
				insert_at_end = false,
				insert_at_start = false,
				-- Sets the maximum padding width with which to surround each tab
				maximum_padding = 1,
				-- Sets the minimum padding width with which to surround each tab
				minimum_padding = 1,
				-- Sets the maximum buffer name length
				maximum_length = 30,
				-- Sets the minimum buffer name length
				minimum_length = 0,
				-- If set, the letters for each buffer in buffer-pick mode will be assigned based on their name
				semantic_letters = true,
				-- Set the filetypes which barbar will offset itself for
				sidebar_filetypes = {
					-- Use the default values: {event = 'BufWinLeave', text = nil}
					NvimTree = true,
				},
				-- New buffer letters are assigned in this order
				letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
				-- Sets the name of unnamed buffers. By default format is "[Buffer X]"
				no_name_title = nil,
			})
		end,
	},
	
	-- Tab-local buffer independence
	{
		"tiagovla/scope.nvim",
		config = function()
			require("scope").setup({
				hooks = {
					pre_tab_leave = function()
						vim.api.nvim_exec_autocmds('User', {pattern = 'ScopeTabLeavePre'})
					end,
					post_tab_enter = function()
						vim.api.nvim_exec_autocmds('User', {pattern = 'ScopeTabEnterPost'})
					end,
				},
			})
		end,
	},
	-- Clean Status Line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "solarized_light",
					component_separators = { left = '', right = ''},
					section_separators = { left = '', right = ''},
				},
				sections = {
					lualine_a = {'mode'},
					lualine_b = {'branch', 'diff', 'diagnostics'},
					lualine_c = {'filename'},
					lualine_x = {'encoding', 'fileformat', 'filetype'},
					lualine_y = {'progress'},
					lualine_z = {'location'}
				},
				extensions = { 'nvim-tree', 'fzf' }
			})
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({
				actions = {
					open_file = {
						quit_on_open = true,
					},
				},
			})
		end,
	},
	"nvim-tree/nvim-web-devicons",

	-- Core functionality
	"nvim-lua/plenary.nvim",
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				toggler = {
					line = "<Leader>cc",
				},
				opleader = {
					line = "<Leader>cc",
				},
			})
		end,
	},
	"tpope/vim-surround",
	"justinmk/vim-sneak",
	
	-- Multiple cursor support
	{
		"mg979/vim-visual-multi",
		branch = "master",
		config = function()
			-- Visual Multi 설정
			vim.g.VM_maps = {
				['Find Under'] = '<C-n>',      -- Ctrl+n으로 같은 단어 선택
				['Find Subword Under'] = '<C-n>',
				['Select All'] = '<C-a>',       -- 모든 매치 선택
				['Skip Region'] = '<C-x>',      -- 현재 선택 건너뛰기
				['Remove Region'] = '<C-p>',    -- 선택 제거
				['Add Cursor Down'] = '<C-Down>',
				['Add Cursor Up'] = '<C-Up>',
			}
			vim.g.VM_theme = 'sand'
			vim.g.VM_highlight_matches = 'underline'
		end,
	},
	{
		"mbbill/undotree",
		config = function()
			vim.g.undotree_WindowLayout = 2
			vim.g.undotree_SplitWidth = 30
		end,
	},

	-- File navigation
	"junegunn/fzf",
	"junegunn/fzf.vim",

	-- LSP and completion
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	"neovim/nvim-lspconfig",
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"pyright",
					"ts_ls",
					"eslint", -- ESLint LSP 추가
					"sqlls",  -- SQL LSP 추가
					"taplo",
					"yamlls",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"lua",
					"python",
					"javascript",
					"typescript",
					"sql",           -- SQL 파서 추가
					"yaml",
					"json",
					"markdown",
					-- "jinja2",     -- 임시로 주석 처리 (설치 실패 가능)
				},
				indent = {
					enable = true,
				},
				highlight = {
					enable = true,
				},
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = false }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",

	-- Git integration
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({})
		end,
	},
	"tpope/vim-fugitive",

	-- Tmux integration
	"alexghergh/nvim-tmux-navigation",

	-- SQL support (dbt 플러그인 제거 - 저장소가 존재하지 않음)
	-- dbt는 기본 SQL 파서와 커스텀 설정으로 지원

	-- Formatting with conform.nvim
	{
		"stevearc/conform.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<space>f",
				function()
					require("conform").format({ 
						async = true, 
						lsp_fallback = true,
						timeout_ms = 5000,
					}, function(err)
						if err then
							vim.notify("포맷팅 실패: " .. tostring(err), vim.log.levels.ERROR)
						else
							vim.notify("포맷팅 완료", vim.log.levels.INFO)
						end
					end)
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		config = function()
			-- Helper function to check if file exists
			local function file_exists(name)
				local f = io.open(name, "r")
				if f ~= nil then
					io.close(f)
					return true
				else
					return false
				end
			end

			-- Helper function to check for ESLint config in project
			local function has_eslint_config()
				local config_files = {
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.json",
					".eslintrc.yml",
					".eslintrc.yaml",
					".eslintrc",
					"eslint.config.js",
					"eslint.config.mjs",
					"eslint.config.cjs",
				}

				local cwd = vim.fn.getcwd()
				for _, config_file in ipairs(config_files) do
					if file_exists(cwd .. "/" .. config_file) then
						return true
					end
				end

				-- Check for eslintConfig in package.json
				if file_exists(cwd .. "/package.json") then
					local package = vim.fn.readfile(cwd .. "/package.json")
					local package_str = table.concat(package, "\n")
					if string.find(package_str, '"eslintConfig"') then
						return true
					end
				end

				return false
			end

			-- Helper function to check for Prettier config in project
			local function has_prettier_config()
				local config_files = {
					".prettierrc",
					".prettierrc.json",
					".prettierrc.yml",
					".prettierrc.yaml",
					".prettierrc.js",
					".prettierrc.cjs",
					".prettierrc.mjs",
					"prettier.config.js",
					"prettier.config.cjs",
					"prettier.config.mjs",
				}

				local cwd = vim.fn.getcwd()
				for _, config_file in ipairs(config_files) do
					if file_exists(cwd .. "/" .. config_file) then
						return true
					end
				end

				-- Check for prettier config in package.json
				if file_exists(cwd .. "/package.json") then
					local package = vim.fn.readfile(cwd .. "/package.json")
					local package_str = table.concat(package, "\n")
					if string.find(package_str, '"prettier"') then
						return true
					end
				end

				return false
			end

			-- Dynamic formatter selection
			local function get_js_formatters()
				local formatters = {}

				-- Check for project-specific configs
				if has_eslint_config() then
					-- ESLint가 있으면 우선 사용
					table.insert(formatters, "eslint_d")
				elseif has_prettier_config() then
					-- ESLint가 없고 Prettier만 있으면 Prettier 사용
					table.insert(formatters, "prettier")
				else
					-- 둘 다 없으면 기본값 (eslint_d)
					table.insert(formatters, "eslint_d")
				end

				return formatters
			end

			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_format", "ruff_organize_imports" },
					-- JavaScript/TypeScript: 동적으로 포맷터 선택
					javascript = get_js_formatters,
					typescript = get_js_formatters,
					javascriptreact = get_js_formatters,
					typescriptreact = get_js_formatters,
					-- SQL formatting with sqlfmt (dbt/Snowflake compatible)
				sql = { "sqlfmt" },
				dbt = { "sqlfmt" },  -- dbt files also use sqlfmt
					-- JSON/YAML/Markdown: 항상 prettier 사용
					json = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
				},
				format_on_save = {
					timeout_ms = 5000,
					lsp_fallback = false,
				},
			})
		end,
	},

	-- Linting with nvim-lint
	{
		"mfussenegger/nvim-lint",
		dependencies = { "williamboman/mason.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				python = { "ruff" },
				-- sql = { "sqlfluff" },  -- sqlfluff는 dbt 템플릿 때문에 임시 비활성화
			}

			-- Create an autocommand to trigger linting
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},

	-- Mason integration for formatters and linters
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"stylua",
					"eslint_d",
					"prettier",
					"ruff",
					"sqlfmt",    -- SQL 포매터
					"sqlfluff",  -- SQL 린터 (dbt 지원)
				},
				automatic_installation = true,
			})
		end,
	},
}
