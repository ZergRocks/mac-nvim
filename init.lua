-- Load core settings first
require("core")

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

-- Load keymaps after plugins are loaded
require("keymaps")

-- Load rock-solid clipboard solution
require("clipboard_config")