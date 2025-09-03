-- 완전히 새로운 접근: 가장 안정적인 클립보드 솔루션

local M = {}

-- 시스템 클립보드 설정 (macOS)
if vim.fn.has('mac') == 1 then
  vim.g.clipboard = {
    name = 'macOS-clipboard',
    copy = {
      ['+'] = 'pbcopy',
      ['*'] = 'pbcopy',
    },
    paste = {
      ['+'] = 'pbpaste',
      ['*'] = 'pbpaste',
    },
    cache_enabled = 0,
  }
end

-- 클립보드 옵션
vim.opt.clipboard = "unnamedplus"

-- Visual 모드에서 선택된 텍스트 가져오기 (안전한 방법)
local function get_visual_selection()
  -- 현재 선택 영역의 마크 저장
  local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
  local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
  
  -- 선택 모드 확인
  local mode = vim.fn.visualmode()
  
  if mode == 'V' then
    -- 라인 단위 선택
    local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
    return table.concat(lines, '\n')
  elseif mode == 'v' then
    -- 일반 선택
    if start_row == end_row then
      -- 단일 라인 선택
      local line = vim.api.nvim_buf_get_lines(0, start_row - 1, start_row, false)[1]
      return line:sub(start_col, end_col)
    else
      -- 다중 라인 선택
      local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
      -- 첫 줄과 마지막 줄 처리
      if #lines > 0 then
        lines[1] = lines[1]:sub(start_col)
        lines[#lines] = lines[#lines]:sub(1, end_col)
      end
      return table.concat(lines, '\n')
    end
  elseif mode == '\22' then  -- Ctrl-V (블록 선택)
    -- 블록 선택 처리
    local lines = {}
    for row = start_row, end_row do
      local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
      if line then
        table.insert(lines, line:sub(start_col, end_col))
      end
    end
    return table.concat(lines, '\n')
  end
  
  return ""
end

-- 안전한 클립보드 복사 함수
function M.safe_yank_to_clipboard()
  -- Visual 모드인지 확인
  local mode = vim.fn.mode()
  if not (mode == 'v' or mode == 'V' or mode == '\22') then
    -- Visual 모드가 아니면 일반 yank 사용
    vim.cmd('normal! "+y')
    print("📋 Yanked to clipboard")
    return
  end
  
  -- Visual 모드에서 텍스트 가져오기
  local text = get_visual_selection()
  
  if text == "" then
    print("⚠️  No text selected")
    return
  end
  
  -- 클립보드에 복사 (여러 방법 시도)
  local success = false
  
  -- 방법 1: vim 레지스터 사용
  vim.fn.setreg('+', text)
  vim.fn.setreg('*', text)
  
  -- 방법 2: pbcopy 직접 호출
  if vim.fn.executable('pbcopy') == 1 then
    local handle = io.popen('pbcopy', 'w')
    if handle then
      handle:write(text)
      handle:close()
      success = true
    end
  end
  
  -- 방법 3: system 명령 사용
  if not success then
    vim.fn.system('pbcopy', text)
    success = true
  end
  
  -- 피드백
  if success then
    local preview = text:gsub('\n', ' '):sub(1, 40)
    print(string.format('📋 Copied: "%s%s"', preview, #text > 40 and '...' or ''))
  else
    print("❌ Failed to copy to clipboard")
  end
  
  -- Escape 키로 Visual 모드 종료 (안전한 방법)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end

-- Normal 모드에서 전체 줄 복사
function M.yank_line_to_clipboard()
  local line = vim.api.nvim_get_current_line()
  
  -- 클립보드에 복사
  vim.fn.setreg('+', line .. '\n')
  vim.fn.system('pbcopy', line .. '\n')
  
  print('📋 Line copied to clipboard')
end

-- Normal 모드에서 단어 복사
function M.yank_word_to_clipboard()
  local word = vim.fn.expand('<cword>')
  
  -- 클립보드에 복사
  vim.fn.setreg('+', word)
  vim.fn.system('pbcopy', word)
  
  print(string.format('📋 Word copied: "%s"', word))
end

-- 클립보드에서 붙여넣기
function M.paste_from_clipboard()
  local text = vim.fn.getreg('+')
  if text and text ~= '' then
    -- 현재 위치에 붙여넣기
    vim.cmd('normal! "+p')
    print('📋 Pasted from clipboard')
  else
    print('⚠️  Clipboard is empty')
  end
end

-- 클립보드 테스트
function M.test()
  print("🧪 Testing clipboard...")
  
  -- pbcopy/pbpaste 확인
  if vim.fn.executable('pbcopy') ~= 1 then
    print("❌ pbcopy not found")
    return
  end
  
  if vim.fn.executable('pbpaste') ~= 1 then
    print("❌ pbpaste not found")
    return
  end
  
  -- 테스트 텍스트
  local test = "Test " .. os.date("%H:%M:%S")
  
  -- 복사 테스트
  vim.fn.system('pbcopy', test)
  local result = vim.fn.system('pbpaste'):gsub('\n', '')
  
  if result == test then
    print("✅ Clipboard working correctly!")
    print("   pbcopy/pbpaste: OK")
    print("   System clipboard: OK")
  else
    print("❌ Clipboard test failed")
    print("   Expected: " .. test)
    print("   Got: " .. result)
  end
end

return M