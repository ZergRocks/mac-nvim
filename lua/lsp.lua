-- LSP configuration that will be loaded after plugins
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Use an on_attach function to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gK", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gk", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					-- 포맷팅은 conform.nvim의 <space>f가 처리하므로 제거
					-- vim.keymap.set("n", "<space>f", function()
					--   vim.lsp.buf.format({ async = true })
					-- end, opts)
				end,
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")

			-- Python
			lspconfig["pyright"].setup({
				capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							diagnosticMode = "openFilesOnly",
							typeCheckingMode = "off",
						},
					},
				},
			})

			-- Lua
			lspconfig["lua_ls"].setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = {
								"vim",
							},
						},
					},
				},
			})

			-- ESLint LSP configuration
			lspconfig["eslint"].setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- ESLint의 포맷팅 기능 비활성화 (conform.nvim이 처리)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
				settings = {
					validate = "on",
					packageManager = "npm",
					autoFixOnSave = false, -- conform.nvim이 처리하므로 비활성화
					codeActionOnSave = {
						enable = false, -- conform.nvim이 처리
						mode = "all",
					},
					format = false, -- 포맷팅은 conform.nvim이 처리
					quiet = false,
					onIgnoredFiles = "off",
					rulesCustomizations = {},
					run = "onType",
					problems = {
						shortenToSingleLine = false,
					},
					-- 프로젝트의 ESLint 설정 자동 감지
					workingDirectory = {
						mode = "auto",
					},
				},
			})

			-- TypeScript/JavaScript LSP
			lspconfig["ts_ls"].setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- TypeScript 서버의 포맷팅 기능 비활성화 (conform.nvim이 처리)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
				settings = {
					typescript = {
						format = {
							enable = false, -- conform.nvim이 처리
						},
					},
					javascript = {
						format = {
							enable = false, -- conform.nvim이 처리
						},
					},
				},
			})

			-- Setup remaining LSP servers
			local servers = { "taplo", "yamlls" }

			for _, server in ipairs(servers) do
				lspconfig[server].setup({
					capabilities = capabilities,
				})
			end
		end,
	},
}

