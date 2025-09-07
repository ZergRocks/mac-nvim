# Mac Neovim Development Environment

> 🚀 macOS에 최적화된 Neovim 개발 환경 자동 설정  
> Solarized Light 테마 기반의 통합 개발 환경 (Neovim + Tmux + Zsh)

## ✨ 핵심 기능

### 🎯 주요 특징
- **원클릭 설치**: `./install.sh`로 전체 환경 자동 구성
- **빠른 시작**: 약 0.26초의 빠른 부팅 시간
- **탭별 버퍼 독립성**: 탭마다 독립적인 버퍼 목록 관리
- **통합 환경**: Neovim + Tmux + Zsh 완벽 통합

### 🛠️ 개발 도구
- **LSP 지원**: Lua, Python, TypeScript, YAML, TOML
- **자동 포매팅**: ruff, eslint_d, stylua
- **Git 통합**: Fugitive + Gitsigns
- **파일 탐색**: FZF 기반 빠른 검색

## 📦 빠른 설치

```bash
# 1. 레포지토리 클론
git clone https://github.com/your-username/mac-nvim.git ~/Workspace/mac-nvim
cd ~/Workspace/mac-nvim

# 2. 자동 설치 실행
./install.sh

# 3. Neovim 실행 (플러그인 자동 설치)
nvim
```

## 📁 프로젝트 구조

```
mac-nvim/
├── init.lua                 # Neovim 메인 설정
├── lua/
│   ├── core.lua            # 핵심 Vim 설정
│   ├── plugins.lua         # 플러그인 정의
│   ├── lsp.lua             # 언어 서버 설정
│   ├── keymaps.lua         # 키 매핑
│   └── modules/            # 추가 모듈
│       ├── ui/             # UI 관련 (탭, 버퍼, winbar)
│       └── experimental/   # 실험적 기능
├── tmux.conf               # Tmux 설정
├── zshrc                   # Zsh 설정
├── install.sh              # 자동 설치 스크립트
└── docs/                   # 문서
    ├── dev-notes/          # 개발 노트
    └── archive/            # 아카이브
```

## ⌨️ 주요 키 매핑

### 기본
- **리더 키**: `,`
- **Escape 대체**: `<C-c>`

### 파일 탐색
- `<Leader>f` - 파일 찾기 (FZF)
- `<Leader>b` - 버퍼 전환
- `<Leader>nn` - 파일 트리 토글
- `<Leader>nt` - 현재 파일 트리에서 찾기

### Git
- `<Leader>gs` - Git 상태
- `<Leader>gd` - Git diff
- `<Leader>gg` - Git blame
- `<Leader>gh` - Hunk diff

### LSP
- `gD` - 정의로 이동
- `gK` - 문서 보기
- `gr` - 참조 찾기
- `<space>rn` - 심볼 이름 변경
- `<space>f` - 코드 포매팅

### 창 관리
- `<C-h/j/k/l>` - 창 이동 (Neovim + Tmux 통합)
- `bn` / `bm` - 버퍼 이동
- `bd` - 버퍼 닫기

## 🔌 주요 플러그인

### 핵심
- **lazy.nvim** - 플러그인 관리자
- **nvim-solarized-lua** - Solarized Light 테마
- **which-key.nvim** - 키 바인딩 힌트
- **Comment.nvim** - 스마트 주석

### 개발 도구
- **mason.nvim** - LSP 서버 관리
- **nvim-lspconfig** - LSP 설정
- **nvim-cmp** - 자동완성
- **nvim-treesitter** - 구문 강조
- **none-ls.nvim** - 포매팅/린팅

### UI
- **lualine.nvim** - 상태 표시줄
- **bufferline.nvim** - 버퍼 탭
- **nvim-tree.lua** - 파일 탐색기

## 🔧 언어 지원

| 언어 | LSP | 포매터 | 기능 |
|-----|-----|--------|------|
| **Lua** | lua_ls | stylua | Neovim 설정 개발 |
| **Python** | pyright | ruff | 데이터 분석, 스크립트 |
| **JavaScript/TypeScript** | ts_ls | eslint_d | 웹 개발 |
| **YAML/TOML** | yamlls, taplo | taplo | 설정 파일 |

## 🚀 사용법

### 첫 실행
```bash
nvim                    # 플러그인 자동 설치 (1-2분)
:checkhealth           # 상태 확인
:Mason                 # LSP 서버 관리
:Lazy                  # 플러그인 관리
```

### 일상 워크플로우
```bash
# 프로젝트 열기
nvim .

# 파일 검색
<Leader>f

# Git 상태 확인
<Leader>gs

# 코드 포매팅
<space>f
```

## 📊 성능

- **시작 시간**: ~260ms
- **메모리 사용**: 기본 25MB, LSP 포함 80MB
- **플러그인 수**: 37개 (최적화됨)

## 🔍 문제 해결

### LSP 문제
```vim
:LspInfo          " LSP 상태 확인
:Mason            " LSP 서버 재설치
:checkhealth lsp  " 건강 상태 점검
```

### 플러그인 업데이트
```vim
:Lazy update      " 모든 플러그인 업데이트
:Lazy sync        " 동기화
```

## 🎯 최근 개선 사항

### 탭별 버퍼 독립성
- 각 탭이 독립적인 버퍼 목록 유지
- Winbar에 현재 탭의 버퍼만 표시
- 효율적인 멀티 프로젝트 작업 지원

### 성능 최적화
- 지연 로딩으로 시작 시간 단축
- 필수 플러그인만 포함 (68개 → 37개)
- 메모리 사용량 최적화

## 📝 커스터마이징

### 새 언어 추가
```lua
-- lua/plugins.lua에서 mason-lspconfig 섹션 수정
ensure_installed = {
  "lua_ls",
  "pyright",
  "your_language_server",  -- 추가
}
```

### 키 매핑 변경
```lua
-- lua/keymaps.lua에서 수정
vim.keymap.set('n', '새키', '명령어', { desc = '설명' })
```

## 📄 라이센스

MIT License - 자유롭게 사용 및 수정 가능

---

**💡 도움말**: 문제가 있으면 [Issues](https://github.com/your-username/mac-nvim/issues)에 문의하세요.  
**📚 문서**: 자세한 개발 노트는 `docs/dev-notes/` 참조