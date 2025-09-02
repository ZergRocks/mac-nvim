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
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "ruff_format", "ruff_organize_imports" },
          javascript = { "eslint_d" },
          typescript = { "eslint_d" },
          javascriptreact = { "eslint_d" },
          typescriptreact = { "eslint_d" },
          sql = { "sqlfmt" },
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
        -- SQLFluff는 레거시 - sqlfmt 사용
        -- sql = {},  -- Linting 비활성화 (sqlfmt는 포맷터만 제공)
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
          -- "sqlfluff",  -- 레거시, sqlfmt 사용
        },
        automatic_installation = true,
      })
    end,
  },
}
