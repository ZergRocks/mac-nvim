-- SQL 및 dbt 설정

-- dbt 파일 타입 감지 개선
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.sql", "*.dbt"},
  callback = function()
    vim.bo.filetype = "sql"
    -- dbt 특정 설정
    if vim.fn.search("{{", "n") > 0 or vim.fn.search("{%", "n") > 0 then
      -- dbt 템플릿 감지
      vim.b.dbt_file = true
    end
  end,
})

-- SQL 파일에서 추가 키매핑
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sql",
  callback = function()
    -- SQL 특정 키매핑 (예: 쿼리 실행 등)
    vim.keymap.set("n", "<Leader>q", function()
      print("SQL query execution would go here")
    end, { buffer = true, desc = "Execute SQL query" })
    
    -- dbt 특정 명령
    if vim.b.dbt_file then
      vim.keymap.set("n", "<Leader>dr", function()
        vim.cmd("!dbt run --select " .. vim.fn.expand("%:t:r"))
      end, { buffer = true, desc = "dbt run current model" })
      
      vim.keymap.set("n", "<Leader>dt", function()
        vim.cmd("!dbt test --select " .. vim.fn.expand("%:t:r"))
      end, { buffer = true, desc = "dbt test current model" })
    end
  end,
})

-- Snowflake 특정 구문 지원을 위한 추가 설정
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sql", 
  callback = function()
    -- Snowflake 키워드 추가 하이라이팅 (필요시)
    vim.cmd([[
      syntax keyword sqlKeyword QUALIFY OVER PARTITION ROW_NUMBER RANK DENSE_RANK
      syntax keyword sqlKeyword PERCENTILE_CONT PERCENTILE_DISC WITHIN GROUP
      syntax keyword sqlFunction LEAD LAG FIRST_VALUE LAST_VALUE
    ]])
  end,
})