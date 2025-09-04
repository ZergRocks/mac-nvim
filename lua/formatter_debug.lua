-- SQL Formatter Debug Helper
local M = {}

-- 포맷터 상태 확인 명령
function M.check_formatters()
	local conform = require("conform")
	local formatters = conform.list_formatters()
	
	print("=== 현재 파일 타입: " .. vim.bo.filetype .. " ===")
	print("사용 가능한 포맷터:")
	
	for _, formatter in ipairs(formatters) do
		local info = conform.get_formatter_info(formatter.name)
		if info.available then
			print("  ✅ " .. formatter.name .. " (경로: " .. (info.command or "알 수 없음") .. ")")
		else
			print("  ❌ " .. formatter.name .. " (사용 불가)")
		end
	end
	
	-- SQL 특정 체크
	if vim.bo.filetype == "sql" or vim.bo.filetype == "dbt" then
		print("\n=== SQL 포맷터 상태 ===")
		local sqlfmt_path = vim.fn.expand("~/.local/share/nvim/mason/bin/sqlfmt")
		if vim.fn.executable(sqlfmt_path) == 1 then
			print("sqlfmt: ✅ 설치됨 (" .. sqlfmt_path .. ")")
		else
			print("sqlfmt: ❌ 찾을 수 없음")
		end
		
		-- 설정 파일 체크
		local config_files = {
			"~/.sqlfmt.toml",
			".sqlfmt.toml",
			"~/.sqlfluff",
			".sqlfluff"
		}
		
		print("\n설정 파일:")
		for _, config in ipairs(config_files) do
			local expanded = vim.fn.expand(config)
			if vim.fn.filereadable(expanded) == 1 then
				print("  ✅ " .. config)
			end
		end
	end
end

-- 포맷 테스트 명령
function M.test_format()
	local conform = require("conform")
	
	print("=== 포맷 테스트 시작 ===")
	conform.format({
		async = false,
		lsp_fallback = true,
		timeout_ms = 5000,
		quiet = false,
	}, function(err)
		if err then
			print("❌ 포맷팅 실패: " .. tostring(err))
			print("\n디버그 정보:")
			print("파일 타입: " .. vim.bo.filetype)
			print("파일 경로: " .. vim.fn.expand("%:p"))
			
			-- 에러 세부사항
			if type(err) == "table" then
				for k, v in pairs(err) do
					print("  " .. tostring(k) .. ": " .. tostring(v))
				end
			end
		else
			print("✅ 포맷팅 성공!")
		end
	end)
end

-- 명령어 등록
vim.api.nvim_create_user_command("FormatDebug", function()
	M.check_formatters()
end, { desc = "포맷터 상태 확인" })

vim.api.nvim_create_user_command("FormatTest", function()
	M.test_format()
end, { desc = "포맷 테스트 실행" })

vim.api.nvim_create_user_command("ConformDebug", function()
	vim.cmd("ConformInfo")
end, { desc = "Conform 상세 정보" })

return M