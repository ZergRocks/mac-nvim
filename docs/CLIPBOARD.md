# 클립보드 설정 가이드

## 개요
macOS + tmux 환경에서 고성능 클립보드 통합

## 사용법

| 키 | 모드 | 동작 |
|----|------|------|
| `,y` | Visual | 선택 영역 복사 |
| `,yy` | Normal | 현재 줄 복사 |
| `,Y` | Normal | 줄 끝까지 복사 |
| `,yw` | Normal | 단어 복사 |
| `,p` | Any | 붙여넣기 |
| `,P` | Any | 커서 앞 붙여넣기 |
| `Ctrl+C` | Visual | 대체 복사 방법 |

## 설정 파일
- `lua/optimized_clipboard_config.lua` - 클립보드 설정
- `tmux.conf` - tmux 클립보드 통합

## 테스트
```vim
:ClipboardTest
```

## 성능
- 레이턴시: <5ms (즉시 반응)
- 네이티브 Vim 명령 직접 사용