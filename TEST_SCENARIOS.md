# 탭별 버퍼 독립성 테스트 시나리오

## 🧪 테스트 준비

1. **Neovim 재시작**
   ```bash
   nvim
   ```

2. **디버그 모드 활성화** (선택사항)
   ```vim
   :TabBufferDebug
   ```

## ✅ 테스트 시나리오 1: 기본 격리 테스트

### 단계별 실행:

1. **탭1 설정**
   ```vim
   :e test1.js     " 파일1 열기
   :e test2.js     " 파일2 열기
   :TabBufferList  " 확인: test1.js, test2.js만 표시
   ```

2. **탭2 생성 및 설정**
   ```vim
   :tabnew         " 새 탭 생성 (tn 단축키 가능)
   :e test3.py     " 파일3 열기
   :e test4.py     " 파일4 열기
   :TabBufferList  " 확인: test3.py, test4.py만 표시
   ```

3. **탭1 네비게이션 테스트**
   ```vim
   :tabprev        " 탭1로 돌아가기 (th 단축키 가능)
   ,l              " 다음 버퍼 → test2.js로 이동
   ,l              " 다음 버퍼 → test1.js로 이동 (순환)
   ,h              " 이전 버퍼 → test2.js로 이동
   ```
   
   **기대 결과**: test1.js ↔ test2.js만 순회
   **실패 시**: test3.py나 test4.py로 이동하면 버그!

4. **탭2 네비게이션 테스트**
   ```vim
   :tabnext        " 탭2로 이동 (tl 단축키 가능)
   ,l              " 다음 버퍼 → test4.py로 이동
   ,l              " 다음 버퍼 → test3.py로 이동 (순환)
   ```
   
   **기대 결과**: test3.py ↔ test4.py만 순회
   **실패 시**: test1.js나 test2.js로 이동하면 버그!

## ✅ 테스트 시나리오 2: Winbar 일치성 테스트

1. **탭1 확인**
   ```vim
   :tabfirst
   ```
   - Winbar 표시: `1:test1.js │ [2:test2.js]` (현재 버퍼 대괄호)
   - `,1` 누름 → test1.js로 이동
   - `,2` 누름 → test2.js로 이동

2. **탭2 확인**
   ```vim
   :tablast
   ```
   - Winbar 표시: `1:test3.py │ [2:test4.py]`
   - `,1` 누름 → test3.py로 이동
   - `,2` 누름 → test4.py로 이동

## ✅ 테스트 시나리오 3: 버퍼 추가/삭제

1. **탭1에 새 버퍼 추가**
   ```vim
   :tabfirst
   :e test5.css
   :TabBufferList  " test1.js, test2.js, test5.css 표시
   ,l ,l ,l        " 3개 파일 순회 확인
   ```

2. **탭2 확인 (영향 없어야 함)**
   ```vim
   :tablast
   :TabBufferList  " 여전히 test3.py, test4.py만 표시
   ```

3. **버퍼 삭제 테스트**
   ```vim
   :tabfirst
   ,bd             " 현재 버퍼 삭제
   :TabBufferList  " 2개만 남음
   ```

## ✅ 테스트 시나리오 4: 엣지 케이스

1. **빈 탭 테스트**
   ```vim
   :tabnew
   ,l              " "현재 탭에 버퍼가 없습니다" 메시지
   :e newfile.txt
   ,l              " 이제 작동
   ```

2. **같은 파일 다른 탭**
   ```vim
   :tabfirst
   :e shared.txt   " 탭1에서 열기
   :tabnext
   :e shared.txt   " 탭2에서도 열기
   :tabfirst
   ,l              " 탭1의 버퍼만 순회
   :tabnext
   ,l              " 탭2의 버퍼만 순회
   ```

## 🔍 검증 명령어

### 현재 상태 확인
```vim
:TabBufferList     " 현재 탭의 버퍼 목록
:TabBufferDebug    " 디버그 모드 토글
:WinbarRefresh     " Winbar 새로고침
```

### 문제 발생 시
```vim
:TabBufferCleanup  " 버퍼 리스트 정리
:messages          " 디버그 메시지 확인
```

## ⚠️ 주의사항

1. **:bnext, :bprevious 직접 사용 금지**
   - 이들은 전역 버퍼를 순회함
   - 반드시 `,h` `,l` 사용

2. **버퍼 번호 vs 인덱스**
   - Winbar의 `1:` `2:` 는 인덱스 (순서)
   - 실제 버퍼 번호와 다름

3. **특수 버퍼 제외**
   - NvimTree, help, fzf 등은 자동 제외

## 📊 성공 기준 체크리스트

- [ ] 탭1에서 `,l` → 탭1 버퍼만 순회
- [ ] 탭2에서 `,l` → 탭2 버퍼만 순회
- [ ] Winbar 표시와 실제 버퍼 일치
- [ ] `,1` `,2` `,3` 숫자키 정상 작동
- [ ] 새 버퍼 추가 시 현재 탭에만 추가
- [ ] `,bd` 삭제 시 현재 탭에서만 제거
- [ ] 탭 전환 후 돌아와도 버퍼 위치 유지

## 🐛 버그 리포트 템플릿

문제 발생 시 다음 정보 수집:
```vim
:TabBufferList
:echo vim.t.tab_buffers
:pwd
:version
```