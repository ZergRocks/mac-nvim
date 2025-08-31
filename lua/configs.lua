vim.cmd([[colorscheme solarized]])
vim.o.background = "light"

---------------
-- nvim-tree --
require("nvim-tree").setup({
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
})

---------------
-- which-key --
local wk = require("which-key")
wk.setup({})

--------------
-- Undotree --
vim.g.undotree_WindowLayout = 2
vim.g.undotree_SplitWidth = 30




-------------
-- null-ls --
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    -- lua
    null_ls.builtins.formatting.stylua,

    -- js
    null_ls.builtins.formatting.eslint_d,
    null_ls.builtins.diagnostics.eslint_d,

    -- python
    null_ls.builtins.diagnostics.ruff.with({ extra_args = { "--extend-select", "I" } }),
    null_ls.builtins.formatting.ruff.with({ extra_args = { "--extend-select", "I" } }),
    null_ls.builtins.formatting.ruff_format,

    -- sql
    null_ls.builtins.diagnostics.sqlfluff.with({
      extra_args = { "--dialect", "snowflake" },
    }),
    null_ls.builtins.formatting.sqlfluff.with({
      extra_args = { "--dialect", "snowflake", "-f", "-q", "--FIX-EVEN-UNPARSABLE" },
    }),
  },
  diagnostics_format = "[#{c}] #{m} (#{s})",
  debounce = 250,
})
-- Ref: https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md


------------
-- lualine --
require("lualine").setup({
  options = {
    theme = "solarized_light",
  },
})


----------------
-- bufferline --
require("bufferline").setup()

--------------
-- gitsigns --
require("gitsigns").setup({})

------------------
-- comment --
require('Comment').setup({
  toggler = {
        ---Line-comment toggle keymap
        line = '<Leader>cc',
    },
  opleader = {
        ---Line-comment keymap
        line = '<Leader>cc',
    },
})

-----------
-- Mason --
require("mason").setup()

require("mason-null-ls").setup({
  automatic_installation = true,
  handlers = {},
})

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua",
    "python",
    "javascript",
    "typescript",
    "go",
    "yaml",
    "json",
    "markdown",
  },
  indent = {
    enable = true,
  },
  highlight = {
    enable = true,
  },
})




