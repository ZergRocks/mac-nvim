-- Neovim 기본 설정

-- Leader key 설정 (가장 먼저!)
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- 기본 옵션
vim.opt.number = true              -- 줄 번호 표시
vim.opt.relativenumber = true      -- 상대적 줄 번호
vim.opt.tabstop = 4               -- 탭 너비
vim.opt.shiftwidth = 4            -- 들여쓰기 너비
vim.opt.expandtab = true          -- 탭을 스페이스로 변환
vim.opt.smartindent = true        -- 스마트 들여쓰기
vim.opt.wrap = false              -- 줄 바꿈 비활성화
vim.opt.ignorecase = true         -- 대소문자 무시 검색
vim.opt.smartcase = true          -- 스마트 케이스 검색
vim.opt.hlsearch = false          -- 검색 하이라이트 비활성화
vim.opt.incsearch = true          -- 증분 검색
vim.opt.scrolloff = 8             -- 스크롤 여백
vim.opt.sidescrolloff = 8         -- 가로 스크롤 여백
vim.opt.signcolumn = "yes"        -- 사인 컬럼 항상 표시
vim.opt.updatetime = 50           -- 업데이트 시간 단축
vim.opt.colorcolumn = "80"        -- 80문자 가이드라인

-- 파일 처리
vim.opt.backup = false            -- 백업 파일 생성 안함
vim.opt.swapfile = false          -- 스왑 파일 생성 안함
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true           -- 영구 실행취소

-- 외관
vim.opt.termguicolors = true      -- 24비트 컬러
vim.opt.background = "light"      -- 밝은 배경