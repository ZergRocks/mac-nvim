local map = vim.keymap.set
local opts = { silent = true }

map({ "i", "x" }, "<C-c>", "<C-[>")
map({ "i", "x" }, "<Left>", "<nop>")
map({ "i", "x" }, "<Down>", "<nop>")
map({ "i", "x" }, "<Up>", "<nop>")
map({ "i", "x" }, "<Right>", "<nop>")

map({ "n", "x" }, "<C-J>", "<C-W>j")
map({ "n", "x" }, "<C-K>", "<C-W>k")
map({ "n", "x" }, "<C-H>", "<C-W>h")
map({ "n", "x" }, "<C-L>", "<C-W>l")

map({ "n", "x" }, "bn", ":BufferPrevious<CR>", opts)
map({ "n", "x" }, "bm", ":BufferNext<CR>", opts)
map({ "n", "x" }, "bd", ":BufferClose<CR>", opts)
map({ "n", "x" }, "td", ":tabclose<CR>")
map({ "n", "x" }, "tn", ":tabnew<CR>")
map({ "n", "x" }, "th", ":tabprev<CR>")
map({ "n", "x" }, "tj", ":tabfirst<CR>")
map({ "n", "x" }, "tk", ":tablast<CR>")
map({ "n", "x" }, "tl", ":tabnext<CR>")

map({ "n", "x" }, "H", "^")
map({ "n", "x" }, "L", "g_")

map({ "n", "x" }, ",y", '"+y')
map("n", ",pp", '"+p')
map("n", "<Leader>zz", ":%s/\\s\\+$//e<CR>")

map("n", "<Leader>gn", ":bp<CR>", opts)
map("n", "<Leader>gm", ":bn<CR>", opts)
map("n", "<Leader>gd", ":bd<CR>", opts)

map("n", "<Leader>bb", ":Buffers<CR>", opts)

local status_ok, nvim_tmux_nav = pcall(require, "nvim-tmux-navigation")
if status_ok then
  nvim_tmux_nav.setup({ disable_when_zoomed = true })
  map("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
  map("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
  map("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
  map("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
end

map("n", "<Leader>nn", ":NvimTreeToggle<CR>")
map("n", "<Leader>nt", ":NvimTreeFindFileToggle<CR>")

map("n", "<Leader>f", ":Files<CR>")
map("n", "<Leader>b", ":Buffer<CR>")
map("n", "<Leader>bl", ":BLines<CR>")
map("n", "<Leader>fl", ":Lines<CR>")
map("n", "<Leader>gf", ":GFiles<CR>")
map("n", "<Leader>gs", ":GFiles?<CR>")
map("n", "<Leader>gco", ":Commits<CR>")
map("n", "<Leader>gbc", ":BCommits<CR>")
map("n", "<Leader>aa", ":Ag<CR>")

map("n", "<Leader>gc", ":G checkout ")
map("n", "<Leader>gb", ":G branch ")
map("n", "<Leader>gm", ":G merge ")
map("n", "<Leader>gg", ":G blame<CR>")
map("n", "<Leader>gs", ":G<CR>")
map("n", "<Leader>gd", ":Gdiff<CR>")
map("n", "<Leader>gl", ":G log<CR>")
map("n", "<Leader>gfetch", ":G fetch origin<CR>")
map("n", "<Leader>ggl", ":G pull origin ")
map("n", "<Leader>gpp", ":G push origin ")
map("n", "<Leader>gw", ":Gwrite<CR>", opts)
map("n", "<Leader>gr", ":Gread<CR>", opts)

map("n", "<Leader>u", ":UndotreeToggle<CR>:UndotreeFocus<CR>")

map("n", "<Leader>p", ":Gitsigns preview_hunk_inline<CR>")
map("n", "<Leader>m", ":Gitsigns toggle_current_line_blame<CR>")
map("n", "<Leader>gh", ":Gitsigns diffthis<CR>")

local lsp_opts = { noremap = true, silent = true }
map("n", "<space>e", vim.diagnostic.open_float, lsp_opts)
map("n", "[d", vim.diagnostic.goto_prev, lsp_opts)
map("n", "]d", vim.diagnostic.goto_next, lsp_opts)
map("n", "<space>q", vim.diagnostic.setloclist, lsp_opts)

-- Spectre (전역 찾기&바꾸기)
map("n", "<D-f>", "<cmd>lua require('spectre').toggle()<CR>", { desc = "Toggle Spectre" })
map("n", "<leader>sr", "<cmd>lua require('spectre').toggle()<CR>", { desc = "Toggle Spectre" })
map("n", "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", { desc = "Search current word" })
map("n", "<leader>sf", "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>", { desc = "Search on current file" })
map("v", "<leader>sw", "<esc><cmd>lua require('spectre').open_visual()<CR>", { desc = "Search current word" })


