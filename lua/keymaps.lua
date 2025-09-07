-- vim basics
vim.keymap.set({ "i", "x" }, "<C-c>", "<C-[>")
vim.keymap.set({ "i", "x" }, "<Left>", "<nop>")
vim.keymap.set({ "i", "x" }, "<Down>", "<nop>")
vim.keymap.set({ "i", "x" }, "<Up>", "<nop>")
vim.keymap.set({ "i", "x" }, "<Right>", "<nop>")

vim.keymap.set({ "n", "x" }, "<C-J>", "<C-W>j")
vim.keymap.set({ "n", "x" }, "<C-K>", "<C-W>k")
vim.keymap.set({ "n", "x" }, "<C-H>", "<C-W>h")
vim.keymap.set({ "n", "x" }, "<C-L>", "<C-W>l")

-- VSCode 스타일 버퍼 네비게이션 (barbar 기반)
vim.keymap.set({ "n", "x" }, "bn", ":BufferPrevious<CR>", { desc = "이전 버퍼", silent = true })
vim.keymap.set({ "n", "x" }, "bm", ":BufferNext<CR>", { desc = "다음 버퍼", silent = true })
vim.keymap.set({ "n", "x" }, "bd", ":BufferClose<CR>", { desc = "버퍼 삭제", silent = true })
vim.keymap.set({ "n", "x" }, "td", ":tabclose<CR>")
vim.keymap.set({ "n", "x" }, "tn", ":tabnew<CR>")
vim.keymap.set({ "n", "x" }, "th", ":tabprev<CR>")
vim.keymap.set({ "n", "x" }, "tj", ":tabfirst<CR>")
vim.keymap.set({ "n", "x" }, "tk", ":tablast<CR>")
vim.keymap.set({ "n", "x" }, "tl", ":tabnext<CR>")

vim.keymap.set({ "n", "x" }, "H", "^")
vim.keymap.set({ "n", "x" }, "L", "g_")
-- 클립보드 키매핑은 optimized_clipboard_config.lua에서 처리
-- (중복 제거)
vim.keymap.set("n", "<Leader>zz", ":%s/\\s\\+$//e<CR>")

-- 전역 버퍼 네비게이션 (모든 탭의 버퍼 순회)
vim.keymap.set("n", "<Leader>gn", ":bp<CR>", { desc = "이전 버퍼 (전역)" })
vim.keymap.set("n", "<Leader>gm", ":bn<CR>", { desc = "다음 버퍼 (전역)" })
vim.keymap.set("n", "<Leader>gd", ":bd<CR>", { desc = "버퍼 삭제 (전역)" })

vim.keymap.set("n", "<Leader>bb", ":Buffers<CR>", { desc = "버퍼 목록 (fzf)" })
-- Winbar 버퍼 빠른 전환 (,1 ~ ,9는 winbar_buffers.lua에서 설정)

--------------------------
-- nvim-tmux-navigation --
local status_ok, nvim_tmux_nav = pcall(require, "nvim-tmux-navigation")
if status_ok then
  nvim_tmux_nav.setup({ disable_when_zoomed = true })
  vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
  vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
  vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
  vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
end

---------------
-- nvim-tree --
vim.keymap.set("n", "<Leader>nn", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<Leader>nt", ":NvimTreeFindFileToggle<CR>")

---------
-- fzf --
vim.keymap.set("n", "<Leader>f", ":Files<CR>")
vim.keymap.set("n", "<Leader>b", ":Buffer<CR>")
vim.keymap.set("n", "<Leader>bl", ":BLines<CR>")
vim.keymap.set("n", "<Leader>fl", ":Lines<CR>", { desc = "fzf Lines 검색" })
vim.keymap.set("n", "<Leader>gf", ":GFiles<CR>")
vim.keymap.set("n", "<Leader>gs", ":GFiles?<CR>")
vim.keymap.set("n", "<Leader>gco", ":Commits<CR>")
vim.keymap.set("n", "<Leader>gbc", ":BCommits<CR>")
vim.keymap.set("n", "<Leader>aa", ":Ag<CR>")

--------------
-- Fugitive --
vim.keymap.set("n", "<Leader>gc", ":G checkout ")
vim.keymap.set("n", "<Leader>gb", ":G branch ")
vim.keymap.set("n", "<Leader>gm", ":G merge ")
vim.keymap.set("n", "<Leader>gg", ":G blame<CR>")
vim.keymap.set("n", "<Leader>gs", ":G<CR>")
vim.keymap.set("n", "<Leader>gd", ":Gdiff<CR>")
vim.keymap.set("n", "<Leader>gl", ":G log<CR>")
vim.keymap.set("n", "<Leader>gfetch", ":G fetch origin<CR>")
vim.keymap.set("n", "<Leader>ggl", ":G pull origin ")
vim.keymap.set("n", "<Leader>gpp", ":G push origin ")
vim.keymap.set("n", "<silent> <Leader>gw", ":Gwrite<CR>")
vim.keymap.set("n", "<silent> <Leader>gr", ":Gread<CR>")

--------------
-- Undotree --
vim.keymap.set("n", "<Leader>u", ":UndotreeToggle<CR>:UndotreeFocus<CR>")




--------------
-- gitsigns --
vim.keymap.set("n", "<Leader>p", ":Gitsigns preview_hunk_inline<CR>")
vim.keymap.set("n", "<Leader>m", ":Gitsigns toggle_current_line_blame<CR>")
vim.keymap.set("n", "<Leader>gh", ":Gitsigns diffthis<CR>")


------------
--  lsp  ---
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)


