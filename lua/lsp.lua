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
				end,
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")

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

			lspconfig["lua_ls"].setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = {
								"vim",
							},
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})

			lspconfig["eslint"].setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
				settings = {
					validate = "on",
					packageManager = "npm",
					autoFixOnSave = false,
					codeActionOnSave = {
						enable = false,
						mode = "all",
					},
					format = false,
					quiet = false,
					onIgnoredFiles = "off",
					rulesCustomizations = {},
					run = "onType",
					problems = {
						shortenToSingleLine = false,
					},
					workingDirectory = {
						mode = "auto",
					},
				},
			})

			lspconfig["ts_ls"].setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
				settings = {
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							completeFunctionCalls = true,
						},
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							completeFunctionCalls = true,
						},
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
				},
			})

			lspconfig["rust_analyzer"].setup({
				capabilities = capabilities,
				settings = {
					["rust-analyzer"] = {
						check = {
							command = "clippy",
						},
						cargo = {
							allFeatures = true,
						},
					},
				},
			})

			lspconfig["gopls"].setup({
				capabilities = capabilities,
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			})

			lspconfig["jsonls"].setup({
				capabilities = capabilities,
				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = { enable = true },
					},
				},
			})

			lspconfig["yamlls"].setup({
				capabilities = capabilities,
				settings = {
					yaml = {
						schemas = require("schemastore").yaml.schemas(),
					},
				},
			})

			lspconfig["bashls"].setup({
				capabilities = capabilities,
			})

			lspconfig["cssls"].setup({
				capabilities = capabilities,
			})

			lspconfig["html"].setup({
				capabilities = capabilities,
			})

			lspconfig["tailwindcss"].setup({
				capabilities = capabilities,
			})
		end,
	},
}