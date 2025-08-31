# Mac Neovim 설정

> macOS 환경을 위한 깔끔하고 효율적인 Neovim 설정  
> Solarized Light 테마와 필수 플러그인으로 구성된 개발 환경

## 🌟 주요 특징

### 🎨 통일된 테마 시스템
- **Solarized Light 테마**: Neovim과 Tmux에서 일관된 밝은 톤의 디자인
- **눈의 피로감 최소화**: 밝은 환경에서 장시간 작업에 최적화
- **전문적인 외관**: 모든 상황에 적합한 깔끔한 디자인

### ⚡ 성능 최적화
- **빠른 시작**: 약 0.26초의 빠른 부팅 시간
- **필수 플러그인**: 68개에서 37개로 정제된 플러그인 구성
- **지연 로딩**: Lazy.nvim을 통한 효율적인 플러그인 관리
- **최적화된 설정**: 반응성 높은 편집 환경

### 🛠️ 개발 도구 통합
- **LSP 지원**: Lua, Python, TypeScript, YAML, TOML 언어 서버
- **코드 포매팅**: ruff, eslint_d, sqlfluff를 통한 자동 코드 정리
- **Git 워크플로우**: Fugitive와 Gitsigns로 통합된 Git 작업
- **파일 탐색**: FZF 기반 빠른 파일 검색

## 📦 설치 방법

### 필수 요구사항
```bash
# Homebrew가 설치되어 있어야 합니다
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 필수 패키지 설치
brew install neovim git node fzf tmux
```

### 자동 설치 (권장)
```bash
cd ~
git clone https://github.com/ZergRocks/mac-nvim.git Workspace/mac-nvim
cd Workspace/mac-nvim
./install.sh
```

### 수동 설치
```bash
# 기존 설정 백업 (있는 경우)
mv ~/.config/nvim ~/.config/nvim.backup

# 설정 파일 연결
ln -s $(pwd)/init.lua ~/.config/nvim/init.lua
ln -s $(pwd)/lua ~/.config/nvim/lua
ln -s $(pwd)/tmux.conf ~/.tmux.conf
ln -s $(pwd)/zshrc ~/.zshrc

# Neovim 실행 (플러그인 자동 설치됨)
nvim
```

## 📁 프로젝트 구조

```
mac-nvim/
├── 📄 init.lua              # Lazy.nvim 설정과 진입점
├── 📁 lua/
│   ├── 🔧 core.lua         # 핵심 Vim 설정
│   ├── 🔌 plugins.lua      # 플러그인 정의 및 설정
│   ├── 🔬 lsp.lua          # 언어 서버 및 자동완성 설정
│   └── ⌨️  keymaps.lua      # 키 매핑 정의
├── 🖥️  tmux.conf            # Tmux 설정
├── 🐚 zshrc                # 쉘 설정
└── 🚀 install.sh           # 설치 스크립트
```

## ⌨️ 키 매핑 가이드

### 기본 설정
| 키 | 기능 |
|---|---|
| `,` | 리더 키 |
| `<C-c>` | Escape 대체 |

### 🗂️ 파일 탐색
| 키 조합 | 기능 |
|---|---|
| `<Leader>f` | 파일 찾기 |
| `<Leader>b` | 버퍼 전환 |
| `<Leader>nn` | 파일 트리 토글 |
| `<Leader>nt` | 현재 파일을 트리에서 찾기 |

### 📝 Git 작업
| 키 조합 | 기능 |
|---|---|
| `<Leader>gs` | Git 상태 보기 |
| `<Leader>gd` | Git diff 보기 |
| `<Leader>gg` | Git blame 보기 |
| `<Leader>gh` | 현재 hunk diff 보기 |
| `<Leader>p` | Hunk 미리보기 |

### 🔧 LSP 기능
| 키 조합 | 기능 |
|---|---|
| `gD` | 정의로 이동 |
| `gK` | 문서 보기 |
| `gr` | 참조 찾기 |
| `<space>rn` | 심볼 이름 변경 |
| `<space>f` | 코드 포매팅 |

### 🪟 창 관리
| 키 조합 | 기능 |
|---|---|
| `<C-h/j/k/l>` | 창 간 이동 (Neovim + Tmux) |
| `bn` / `bm` | 이전/다음 버퍼 |
| `bd` | 버퍼 닫기 |

### 🛠️ 유틸리티
| 키 조합 | 기능 |
|---|---|
| `<Leader>u` | 실행취소 트리 |
| `<Leader>y` | 시스템 클립보드에 복사 |
| `<Leader>zz` | 행 끝 공백 제거 |

## 🔌 플러그인 목록 (37개)

### 핵심 기능
- **nvim-solarized-lua** - Solarized Light 컬러스킴
- **which-key.nvim** - 키 바인딩 힌트
- **Comment.nvim** - 스마트 주석 처리
- **vim-surround** - 텍스트 객체 감싸기
- **vim-sneak** - 빠른 2글자 검색
- **undotree** - 시각적 실행취소 기록

### 파일 관리
- **nvim-tree.lua** - 파일 탐색기
- **fzf** & **fzf.vim** - 퍼지 파일 검색

### Git 통합
- **gitsigns.nvim** - Git 데코레이션 및 hunk 관리
- **vim-fugitive** - Git 명령어 통합

### LSP 및 개발 도구
- **mason.nvim** - LSP 서버 관리
- **mason-lspconfig.nvim** - LSP 서버 자동 설치
- **nvim-lspconfig** - LSP 설정
- **nvim-cmp** - 자동완성
- **nvim-treesitter** - 구문 강조
- **LuaSnip** - 스니펫 엔진

### 코드 포매팅
- **none-ls.nvim** - 포매팅 및 린팅
- **mason-null-ls.nvim** - 포매터 자동 설치

### UI 개선
- **lualine.nvim** - 상태 표시줄
- **bufferline.nvim** - 버퍼 탭
- **nvim-web-devicons** - 파일 아이콘

## 🔧 언어 지원

### 완전 지원 언어
| 언어 | LSP 서버 | 포매터 | 린터 |
|---|---|---|---|
| **Lua** | lua_ls | stylua | lua_ls |
| **Python** | pyright | ruff | ruff |
| **JavaScript/TypeScript** | ts_ls | eslint_d | eslint_d |
| **YAML** | yamlls | - | yamlls |
| **TOML** | taplo | taplo | taplo |
| **SQL** | - | sqlfluff | sqlfluff |

## 🚀 사용 방법

### 첫 실행
1. 설치 후 `nvim` 명령으로 실행
2. 플러그인이 자동으로 설치됨 (약 1-2분 소요)
3. Mason이 언어 서버들을 설치 (추가 1-2분)
4. 설치 완료 후 정상 사용 가능

### 일상적인 워크플로우
```bash
# 프로젝트 디렉토리에서
nvim .                    # 프로젝트 전체 열기
nvim filename.py          # 특정 파일 열기

# Neovim 내에서
:checkhealth             # 건강 상태 확인
:Mason                   # LSP 서버 관리
:Lazy                    # 플러그인 관리
```

## 📊 성능 정보

### 시작 시간 분석
- **플러그인 로딩**: ~150ms
- **LSP 초기화**: ~100ms
- **총 시작 시간**: ~260ms

### 메모리 사용량
- **기본 메모리**: ~25MB
- **LSP 서버 포함**: ~80MB
- **대용량 파일(>1MB)**: ~150MB

## 🔍 문제 해결

### LSP가 작동하지 않는 경우
```bash
# 1. Mason에서 언어 서버 확인
:Mason

# 2. LSP 상태 확인  
:LspInfo

# 3. 건강 상태 점검
:checkhealth lsp
```

### 색상이 제대로 표시되지 않는 경우
```bash
# 터미널 색상 지원 확인
echo $TERM  # screen-256color 또는 xterm-256color가 나와야 함

# iTerm2/Terminal.app에서 true color 지원 확인
export TERM=xterm-256color
```

### Tmux 통합 문제
```bash
# Tmux 설정 재로드
tmux source-file ~/.tmux.conf

# 창 간 이동 테스트
# Ctrl+h/j/k/l로 창 이동 확인
```

### 플러그인 업데이트
```bash
# Neovim에서 실행
:Lazy update              # 모든 플러그인 업데이트
:Mason                    # LSP 서버 관리
```

## 🎯 고급 사용법

### 커스터마이징
1. `lua/core.lua` - 기본 Vim 설정 수정
2. `lua/plugins.lua` - 플러그인 추가/제거
3. `lua/keymaps.lua` - 키 매핑 커스터마이징
4. `lua/lsp.lua` - 언어 서버 설정 조정

### 새로운 언어 추가
```lua
-- lua/plugins.lua의 mason-lspconfig 섹션에 추가
ensure_installed = {
  "lua_ls",
  "pyright", 
  "새로운_언어_서버",  -- 여기에 추가
},

-- treesitter 섹션에도 추가
ensure_installed = {
  "lua",
  "python",
  "새로운_언어",  -- 여기에 추가
},
```

## 🤝 기여하기

1. 저장소 포크
2. 기능 브랜치 생성: `git checkout -b feature/새기능`
3. 변경사항 적용 및 테스트
4. 커밋: `git commit -m "feat: 새로운 기능 추가"`
5. 푸시: `git push origin feature/새기능`
6. Pull Request 생성

## 📄 라이센스

MIT 라이센스 - 자유롭게 커스터마이징하여 사용하세요.

## 🙏 감사의 말

- nvim-lua 원본 설정을 기반으로 함
- Ethan Schoonover의 Solarized 테마
- 다양한 플러그인 작성자들의 커뮤니티 기여

---

**💡 팁**: 이 설정은 macOS 개발자를 위해 최적화되었습니다. Linux나 Windows에서 사용하려면 일부 조정이 필요할 수 있습니다.

**🔧 문제가 있으신가요?** [Issues](https://github.com/ZergRocks/mac-nvim/issues)에 문의해 주세요!