# Neovim Deprecation 경고 해결 보고서

## 문제 요약
Neovim 0.11.3에서 다수의 deprecation 경고가 발생했습니다. 주요 문제는 플러그인들이 구버전 API를 사용하고 있었던 것입니다.

## 영향받은 API
1. **vim.str_utfindex** - Nvim 1.0에서 제거 예정
2. **vim.tbl_add_reverse_lookup** - Nvim 0.12에서 제거 예정  
3. **vim.tbl_flatten** - Nvim 0.13에서 제거 예정
4. **vim.validate** - Nvim 1.0에서 제거 예정

## 영향받은 플러그인
- nvim-cmp (자동완성)
- none-ls.nvim (포맷터/린터)
- nvim-tree.lua (파일 탐색기)
- LuaSnip (스니펫 엔진)

## 해결 방법

### 1. Deprecated API 호환성 레이어 생성
- 파일: `/Users/an/.config/nvim/lua/deprecated_fixes.lua`
- 목적: deprecated API에 대한 경고를 억제하고 호환성 제공
- 효과: 플러그인이 업데이트될 때까지 임시 해결책 제공

### 2. 문제가 있는 플러그인 교체
**none-ls.nvim 제거 및 대체:**
- 제거: nvimtools/none-ls.nvim
- 대체:
  - `stevearc/conform.nvim` - 코드 포맷팅
  - `mfussenegger/nvim-lint` - 코드 린팅
  - `WhoIsSethDaniel/mason-tool-installer.nvim` - 포맷터/린터 자동 설치

### 3. 플러그인 구성 개선
- conform.nvim과 nvim-lint로 더 현대적이고 유지보수가 활발한 솔루션 채택
- Mason과의 통합으로 도구 자동 설치 지원
- 언어별 포맷터/린터 구성:
  - Lua: stylua
  - Python: ruff
  - JavaScript/TypeScript: eslint_d, prettier
  - SQL: sqlfluff

## 테스트 결과
✅ Neovim이 에러 없이 정상 시작
✅ 모든 deprecation 경고 제거
✅ 포맷팅 및 린팅 기능 정상 작동

## 향후 권장사항
1. 정기적으로 플러그인 업데이트 실행 (`:Lazy update`)
2. 플러그인의 GitHub 저장소에서 업데이트 상황 모니터링
3. Neovim 1.0 출시 전 deprecated_fixes.lua 제거 가능 여부 확인
4. nvim-tree.lua가 계속 문제를 일으킬 경우 neo-tree.nvim으로 전환 고려

## 사용 방법
- 코드 포맷팅: `<leader>f` 또는 저장 시 자동 포맷팅
- 린팅: 파일 열기/저장/편집 시 자동 실행
- 포맷터/린터 정보 확인: `:ConformInfo`

## 변경 파일 목록
1. `/Users/an/.config/nvim/init.lua` - deprecated_fixes 로드 추가
2. `/Users/an/.config/nvim/lua/deprecated_fixes.lua` - 호환성 레이어 생성
3. `/Users/an/.config/nvim/lua/plugins.lua` - none-ls를 conform/nvim-lint로 교체

---
작성일: 2025-08-31
Neovim 버전: 0.11.3