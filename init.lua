-- Load core settings first
require("core")

-- Load safe API module for error prevention
-- 일시적으로 비활성화 (테스트 중)
-- local safe_api = require("safe_api")
-- safe_api.setup({ debug = false })

-- Load deprecated API fixes before plugins
-- This provides compatibility for plugins using deprecated Neovim APIs
require("deprecated_fixes")

-- Setup lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "lsp" },
  },
  defaults = {
    lazy = false,
  },
  install = {
    colorscheme = { "solarized" },
  },
  checker = { enabled = false },
  concurrency = 50,
})

-- Load optimized fast clipboard solution FIRST (priority over keymaps)
require("optimized_clipboard_config")

-- Load keymaps after clipboard (so clipboard mappings take priority)
require("keymaps")

-- Load SQL and dbt configuration
require("sql_config")

-- Load formatter debug helper
require("formatter_debug")

-- Load tabby configuration for tab management
require("tabby_config")

-- Load tab buffer isolation (탭별 버퍼 독립성)
require("tab_buffer_isolation").setup()

-- Load winbar buffer display
require("winbar_buffers").setup()