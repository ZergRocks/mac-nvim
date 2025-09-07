# CLAUDE.md

Claude Code (claude.ai/code)가 이 저장소 코드를 작업할 때 참조할 가이드입니다.

## 저장소 개요

Solarized Light 테마의 macOS 최적화 Neovim 설정 저장소입니다. 탭-버퍼 독립성, Python 개발 지원, Git 통합에 중점을 둡니다.

## 핵심 아키텍처

### 설정 로딩 순서
1. `init.lua` - lazy.nvim을 부트스트랩하고 모든 모듈을 로드하는 진입점
2. `lua/settings.lua` - 기본 Neovim 옵션 (첫 번째 로드)
3. `lua/keymaps.lua` - 키 매핑 (두 번째 로드)
4. `lua/plugins.lua` - lazy.nvim 스펙을 통한 플러그인 정의
5. `lua/lsp.lua` - 플러그인 의존성으로 로드되는 LSP 설정

### 플러그인 관리 전략
- **lazy.nvim**을 플러그인 매니저로 사용, 단순함을 위해 지연 로딩 비활성화
- `lua/plugins.lua`에서 인라인 설정과 함께 플러그인 정의
- 올바른 로딩 순서를 보장하기 위해 `lua/lsp.lua`에 LSP 설정 분리

### 주요 설계 결정사항
- **탭-버퍼 독립성**: `barbar.nvim` + `scope.nvim`을 사용하여 각 탭이 독립적인 버퍼 목록을 유지
- **LSP 아키텍처**: Mason이 LSP 서버 설치를 관리하고, nvim-lspconfig가 설정을 처리하며, 포매팅은 conform.nvim에 위임
- **Python 환경**: miniconda와 통합되어 LSP에는 pyright, 포매팅/린팅에는 ruff 사용

## 개발 명령어

### 설치 및 설정
```bash
# 전체 설치 (Homebrew, 패키지, Python 환경, 심볼릭 링크)
./install.sh

# 변경 후 수동 Neovim 설정
nvim
:Lazy sync              # 플러그인 업데이트/설치
:Mason                  # LSP 서버 관리
:checkhealth           # 설정 검증
```

### 설정 테스트
```bash
# Neovim 설정 테스트
nvim --headless -c 'checkhealth' -c 'qa'

# 재시작 없이 설정 다시 로드
:source %              # 현재 파일에서
:source $MYVIMRC      # init.lua 다시 로드
```

### 플러그인 관리
```bash
# Neovim에서
:Lazy                  # 플러그인 관리자 UI 열기
:Lazy sync            # 모든 플러그인 업데이트
:Lazy clean           # 사용하지 않는 플러그인 제거
:Lazy profile         # 성능 프로파일링
```

### LSP 작업
```bash
# Neovim에서
:Mason                # LSP 서버 관리자 UI
:MasonInstall pyright # 특정 LSP 설치
:LspInfo             # 현재 버퍼 LSP 상태
:LspRestart          # LSP 서버 재시작
```

## File Relationships

### Symlink Structure
The installation creates these symlinks:
- `~/.config/nvim/init.lua` → `./init.lua`
- `~/.config/nvim/lua/` → `./lua/`
- `~/.zshrc` → `./zshrc`
- `~/.tmux.conf` → `./tmux.conf`
- `~/mac-nvim/` → Current directory

### Configuration Dependencies
- `init.lua` requires all files in `lua/` directory
- `lua/lsp.lua` depends on Mason and nvim-cmp being loaded first
- `lua/plugins.lua` contains all plugin specifications including LSP module
- Keymaps reference plugin commands, so plugins must load before keymaps are used

## Security Considerations

### Token Management
- GitHub tokens and sensitive data must be stored in `~/.zshrc.local` (not tracked)
- The `zshrc` file sources `~/.zshrc.local` if it exists
- `.gitignore` excludes `.zshrc.local`, `.env`, and other sensitive files
- Never commit files containing patterns like `ghp_`, `sk-`, or other API tokens

### Git History
- Repository has been cleaned with BFG Repo-Cleaner
- Force pushes may be required after security cleanups
- Always verify no sensitive data in commits before pushing

## Common Modifications

### Adding a New Plugin
1. Add plugin spec to `lua/plugins.lua` in the return table
2. Include any required dependencies in the spec
3. Add keymaps to `lua/keymaps.lua` if needed
4. Run `:Lazy sync` to install

### Adding LSP Support for a Language
1. Add server configuration to `lua/lsp.lua` in the lspconfig section
2. Install the LSP server: `:MasonInstall <server-name>`
3. Add formatter/linter configuration if using conform.nvim/nvim-lint
4. Update README.md's language support table

### Modifying Keybindings
1. Edit `lua/keymaps.lua` for general keymaps
2. LSP-specific keymaps are in the LspAttach autocmd in `lua/lsp.lua`
3. Leader key is `,` (comma), defined in `lua/settings.lua`

## Known Configuration Patterns

### VSCode-style Buffer Management
- Buffers are scoped to tabs via scope.nvim
- `bm`/`bn` navigate buffers within current tab only
- `<Leader>gm`/`<Leader>gn` navigate all buffers globally
- New tabs start with empty buffer list

### LSP Formatting Delegation
- ESLint and TypeScript LSP servers have formatting disabled
- conform.nvim handles all formatting via `<space>f`
- This prevents conflicts between multiple formatters

### Python Development Setup
- Requires miniconda installation (handled by install.sh)
- Pyright provides intelligence, ruff handles formatting
- Virtual environments are auto-detected by pyright