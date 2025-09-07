# Mac Neovim Configuration

> macOS 최적화된 Neovim 설정 (Solarized Light + VSCode 스타일)

## ✨ 주요 특징

- **VSCode 스타일 탭-버퍼 관리**: barbar.nvim + scope.nvim으로 탭별 독립성 완벽 구현
- **빠른 시작**: lazy.nvim 지연 로딩으로 최적화
- **통합 개발 환경**: LSP, 포매팅, Git, 파일 탐색 완벽 통합

## 🚀 설치

```bash
# 클론 및 설치
git clone https://github.com/your-username/mac-nvim.git ~/Workspace/mac-nvim
cd ~/Workspace/mac-nvim
./install.sh

# Neovim 실행
nvim
```

## 📁 구조

```
mac-nvim/
├── init.lua          # 메인 설정
├── lua/
│   ├── plugins.lua   # 플러그인 (barbar.nvim + scope.nvim)
│   ├── keymaps.lua   # 키바인딩
│   ├── settings.lua  # 기본 설정
│   └── lsp.lua       # LSP 설정
├── install.sh        # 설치 스크립트
├── README.md
├── tmux.conf
└── zshrc
```

## ⌨️ 키바인딩

### 파일 & 탐색
- `,f` - 파일 찾기 (FZF)
- `,nn` - 파일 트리 토글
- `,bb` - 버퍼 목록

### 버퍼 & 탭 (VSCode 스타일)
- `bm` - 다음 버퍼 (현재 탭)
- `bn` - 이전 버퍼 (현재 탭)
- `bd` - 버퍼 삭제
- `tn` - 새 탭
- `tl` / `th` - 탭 이동

### 클립보드
- `,y` - 클립보드로 복사
- `,pp` - 클립보드에서 붙여넣기

### Git
- `,gs` - Git 상태
- `,gd` - Git diff
- `,p` - Hunk 미리보기

### LSP
- `<space>f` - 코드 포매팅
- `gD` - 정의로 이동
- `gr` - 참조 찾기
- `[d` / `]d` - 진단 이동

## 🔌 핵심 플러그인

### UI
- **nvim-solarized-lua** - Solarized Light 테마
- **barbar.nvim** - VSCode 스타일 버퍼라인
- **scope.nvim** - 탭별 버퍼 독립성
- **lualine.nvim** - 상태바

### 개발
- **lazy.nvim** - 플러그인 관리
- **mason.nvim** - LSP 관리
- **nvim-cmp** - 자동완성
- **conform.nvim** - 포매팅
- **nvim-lint** - 린팅

### Git
- **gitsigns.nvim** - Git 통합
- **vim-fugitive** - Git 명령어

## 🔧 지원 언어

| 언어 | LSP | 포매터 |
|-----|-----|--------|
| Lua | lua_ls | stylua |
| Python | pyright | ruff |
| JavaScript/TypeScript | ts_ls | eslint_d/prettier |
| JSON/YAML | yamlls | prettier |

## 📝 사용법

```bash
# 플러그인 관리
:Lazy

# LSP 서버 관리  
:Mason

# 건강 상태 확인
:checkhealth
```

## 라이센스

MIT License