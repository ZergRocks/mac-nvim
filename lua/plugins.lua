return {
  -- Theme (Solarized Light)
  {
    "ishan9299/nvim-solarized-lua",
    config = function()
      vim.cmd([[colorscheme solarized]])
      vim.o.background = "light"
    end,
  },

  -- Essential UI
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "solarized_light",
        },
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
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup()
    end,
  },

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
      require('Comment').setup({
        toggler = {
          line = '<Leader>cc',
        },
        opleader = {
          line = '<Leader>cc',
        },
      })
    end,
  },
  "tpope/vim-surround",
  "justinmk/vim-sneak",
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

  -- Formatting
  {
    "nvimtools/none-ls.nvim",
    commit = "7e146f3a188853843bb4ca1bff24c912bb9b7177",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
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
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
    config = function()
      require("mason-null-ls").setup({
        automatic_installation = true,
        handlers = {},
      })
    end,
  },
}