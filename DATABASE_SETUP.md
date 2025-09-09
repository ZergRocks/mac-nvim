# vim-dadbod 데이터베이스 연결 가이드

## 🚀 빠른 시작

1. **Neovim 재시작** 후 플러그인 설치:
   ```
   :Lazy sync
   ```

2. **데이터베이스 UI 열기**:
   ```
   ,dd  (또는 :DBUIToggle)
   ```

## 🔌 데이터베이스 연결 방법

### 방법 1: 대화형 연결 추가
```
:DBUIAddConnection
```
그 다음 데이터베이스 타입과 연결 정보를 입력합니다.

### 방법 2: 연결 URL 직접 설정

**PostgreSQL:**
```
postgresql://username:password@localhost:5432/database_name
```

**MySQL:**
```
mysql://username:password@localhost:3306/database_name
```

**SQLite:**
```
sqlite:/absolute/path/to/database.db
```

**DuckDB:**
```
duckdb:/path/to/database.duckdb
```

**Snowflake:**
```
snowflake://username:password@account.region/database/schema?warehouse=warehouse_name
```

## 📝 연결 설정 예제

### 환경 변수 사용 (권장)
`~/.zshrc.local`에 추가:
```bash
export DATABASE_URL="postgresql://postgres:mypassword@localhost:5432/mydb"
export DEV_DB="mysql://root:password@localhost:3306/dev_db"
export SQLITE_DB="sqlite:~/databases/local.db"
```

### Lua 설정으로 다중 연결
`init.lua`에 추가:
```lua
vim.g.dbs = {
    dev = 'postgresql://postgres:password@localhost:5432/dev_db',
    staging = 'postgresql://postgres:password@staging-host:5432/staging_db',
    local_sqlite = 'sqlite:~/projects/app.db',
    analytics = 'duckdb:~/data/analytics.duckdb'
}
```

## ⌨️ 주요 키바인딩

| 키 | 기능 |
|---|---|
| `,dd` | Database UI 토글 |
| `,df` | DB 버퍼 찾기 |
| `,dr` | DB 버퍼 이름 변경 |
| `,dl` | 마지막 쿼리 정보 |

## 🛠️ 기본 사용법

### 1. 데이터베이스 탐색
- `,dd`로 DBUI 열기
- `o`로 데이터베이스/테이블 확장
- `<Enter>`로 쿼리 실행

### 2. SQL 쿼리 작성
- 새 쿼리: `A` (Add query)
- 기존 쿼리 수정: 파일 선택 후 편집
- 실행: `:w` (저장) 또는 `<Leader>R`

### 3. 테이블 데이터 보기
- 테이블에서 `<Enter>`: `SELECT * FROM table LIMIT 200`
- `S`: 테이블 스키마 보기

## 🔒 보안 팁

1. **자격 증명 보호**:
   - `.zshrc.local` 사용 (Git 추적 안됨)
   - 환경 변수 활용
   - 직접 코드에 패스워드 저장 금지

2. **연결 문자열에서 특수 문자**:
   - `@` → `%40`
   - `#` → `%23`
   - `?` → `%3F`

## 📊 고급 기능

### 쿼리 저장소
저장된 쿼리는 다음 위치에 보관됩니다:
```
~/.local/share/nvim/dadbod_ui/
```

### SQL 자동완성
SQL 파일에서 자동으로 활성화됩니다:
- 테이블 이름
- 컬럼 이름  
- SQL 키워드

### 결과 포맷팅
- 결과는 마크다운 테이블 형식으로 표시
- 구문 강조 자동 적용

## 🚨 문제 해결

### "No database found" 오류
1. 연결 URL 형식 확인
2. 데이터베이스 서버 실행 상태 확인
3. 네트워크 연결 확인

### 플러그인 로드 실패
```
:checkhealth vim-dadbod
```

### 자동완성이 작동하지 않는 경우
SQL 파일에서 수동으로 활성화:
```
:lua require('cmp').setup.buffer({ sources = { { name = 'vim-dadbod-completion' } } })
```

## 📚 추가 리소스

- [vim-dadbod 공식 문서](https://github.com/tpope/vim-dadbod)
- [vim-dadbod-ui 사용법](https://github.com/kristijanhusak/vim-dadbod-ui)
- [지원되는 데이터베이스 목록](https://github.com/tpope/vim-dadbod#adapters)