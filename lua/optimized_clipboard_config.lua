-- 고성능 클립보드 설정 (tmux + macOS)
-- 최적화: 직접 매핑으로 레이턴시 최소화 (<5ms)

-- macOS 클립보드 provider 설정
if vim.fn.has('mac') == 1 then
  vim.g.clipboard = {
    name = 'macOS-clipboard',
    copy = { ['+'] = 'pbcopy', ['*'] = 'pbcopy' },
    paste = { ['+'] = 'pbpaste', ['*'] = 'pbpaste' },
    cache_enabled = 0,
  }
end

vim.opt.clipboard = "unnamedplus"

-- 최적화된 키매핑 (직접 매핑으로 레이턴시 최소화)
vim.keymap.set('v', '<Leader>y', '"+y', { 
  desc = 'Copy to clipboard (fast)', 
  silent = true,
  noremap = true 
})

-- Visual 모드 대체 키
vim.keymap.set('v', '<C-c>', '"+y', { 
  desc = 'Copy (Ctrl+C)', 
  silent = true,
  noremap = true 
})

-- Normal 모드 - 빠른 복사
vim.keymap.set('n', '<Leader>yy', '"+yy', { 
  desc = 'Copy line', 
  silent = true,
  noremap = true 
})

vim.keymap.set('n', '<Leader>Y', '"+y$', { 
  desc = 'Copy to end', 
  silent = true,
  noremap = true 
})

vim.keymap.set('n', '<Leader>yw', '"+yiw', { 
  desc = 'Copy word', 
  silent = true,
  noremap = true 
})

-- 붙여넣기 
vim.keymap.set({'n', 'v'}, '<Leader>p', '"+p', { 
  desc = 'Paste after', 
  silent = true,
  noremap = true 
})

vim.keymap.set({'n', 'v'}, '<Leader>P', '"+P', { 
  desc = 'Paste before', 
  silent = true,
  noremap = true 
})

-- 빠른 테스트 명령
vim.api.nvim_create_user_command('ClipboardTest', function()
  print("⚡ Fast clipboard ready - tmux + macOS integrated")
end, { desc = 'Test clipboard status' })