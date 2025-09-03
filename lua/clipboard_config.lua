-- 클립보드 설정 및 키매핑

-- 안전한 클립보드 모듈 로드
local clipboard = require('rock_solid_clipboard')

-- Leader 키 확인 (기본값: ,)
vim.g.mapleader = vim.g.mapleader or ','

-- 키매핑 설정

-- Visual 모드 매핑 (가장 중요)
-- leader + y로 시스템 클립보드에 복사
vim.keymap.set({'v', 'x'}, '<Leader>y', function()
  clipboard.safe_yank_to_clipboard()
end, { desc = 'Copy to system clipboard', silent = false })

-- 대체 키매핑 (Ctrl+C)
vim.keymap.set({'v', 'x'}, '<C-c>', function()
  clipboard.safe_yank_to_clipboard()
end, { desc = 'Copy to clipboard (Ctrl+C)', silent = false })

-- Normal 모드 매핑
-- 전체 줄 복사
vim.keymap.set('n', '<Leader>yy', function()
  clipboard.yank_line_to_clipboard()
end, { desc = 'Copy line to clipboard' })

-- 단어 복사
vim.keymap.set('n', '<Leader>yw', function()
  clipboard.yank_word_to_clipboard()
end, { desc = 'Copy word to clipboard' })

-- 줄 끝까지 복사 (일반 vim 명령 사용)
vim.keymap.set('n', '<Leader>Y', '"+y$', { desc = 'Copy to end of line' })

-- 붙여넣기 매핑
vim.keymap.set({'n', 'v'}, '<Leader>p', function()
  clipboard.paste_from_clipboard()
end, { desc = 'Paste from clipboard' })

-- 대체 붙여넣기 (Ctrl+V는 이미 Visual Block에 사용되므로 다른 키 사용)
vim.keymap.set({'n', 'v'}, '<Leader>P', '"+P', { desc = 'Paste before cursor' })

-- 명령어 등록
vim.api.nvim_create_user_command('ClipboardTest', function()
  clipboard.test()
end, { desc = 'Test clipboard functionality' })

vim.api.nvim_create_user_command('ClipboardHelp', function()
  print([[
╭─────────────────────────────────────╮
│       📋 Clipboard Commands         │
├─────────────────────────────────────┤
│ Visual Mode:                        │
│   ,y     - Copy selection           │
│   Ctrl+C - Copy selection (alt)     │
│                                     │
│ Normal Mode:                        │
│   ,yy    - Copy entire line        │
│   ,yw    - Copy word under cursor  │
│   ,Y     - Copy to end of line     │
│                                     │
│ Paste:                              │
│   ,p     - Paste after cursor      │
│   ,P     - Paste before cursor     │
│                                     │
│ Commands:                           │
│   :ClipboardTest - Test clipboard  │
│   :ClipboardHelp - Show this help  │
╰─────────────────────────────────────╯
  ]])
end, { desc = 'Show clipboard help' })

-- 시작 시 메시지
vim.defer_fn(function()
  print("📋 Clipboard ready. Use :ClipboardHelp for commands")
end, 100)

return clipboard