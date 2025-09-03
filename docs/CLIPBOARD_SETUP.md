# 클립보드 설정 가이드

## 현재 설정
- **핵심 모듈**: `lua/rock_solid_clipboard.lua`
- **설정 파일**: `lua/clipboard_config.lua`
- **초기화**: `init.lua`에서 자동 로드

## 사용법

### 키 매핑
| 모드 | 키 | 동작 |
|------|-----|------|
| Visual | `,y` | 시스템 클립보드로 복사 |
| Visual | `Ctrl+C` | 대체 복사 방법 |
| Normal | `,yy` | 현재 줄 복사 |
| Normal | `,yw` | 단어 복사 |
| Normal | `,Y` | 줄 끝까지 복사 |
| Any | `,p` | 붙여넣기 |
| Any | `,P` | 커서 앞에 붙여넣기 |

### 명령어
- `:ClipboardTest` - 클립보드 테스트
- `:ClipboardHelp` - 도움말 표시

## tmux 환경
tmux.conf에 다음 설정이 포함되어 있습니다:
- `set-clipboard on`
- copy-mode-vi에서 pbcopy 사용
- tmux-yank 플러그인 통합

## 문제 해결
1. Neovim 재시작: `nvim`
2. 상태 확인: `:ClipboardTest`
3. tmux 재로드: `tmux source ~/.tmux.conf`