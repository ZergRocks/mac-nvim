-- Deprecated API compatibility layer for Neovim 0.11+
-- This file provides backward compatibility for plugins using deprecated APIs

-- Fix for vim.str_utfindex deprecation (will be removed in Nvim 1.0)
if vim.str_utfindex and not rawget(vim, '_str_utfindex_fixed') then
  local original_str_utfindex = vim.str_utfindex
  vim.str_utfindex = function(str, encoding, index, strict_indexing)
    -- Handle old signature: vim.str_utfindex(str, index)
    if type(encoding) == 'number' and index == nil then
      -- Old API call detected, adapt to new signature
      return original_str_utfindex(str, 'utf-8', encoding, false)
    end
    -- New API call, pass through
    return original_str_utfindex(str, encoding, index, strict_indexing)
  end
  rawset(vim, '_str_utfindex_fixed', true)
end

-- Fix for vim.tbl_add_reverse_lookup deprecation (will be removed in Nvim 0.12)
if vim.tbl_add_reverse_lookup and not rawget(vim, '_tbl_add_reverse_lookup_fixed') then
  local original_tbl_add_reverse_lookup = vim.tbl_add_reverse_lookup
  vim.tbl_add_reverse_lookup = function(tbl)
    -- Suppress deprecation warning by using the function directly
    local result = {}
    for k, v in pairs(tbl) do
      result[k] = v
      if type(v) == 'string' then
        result[v] = k
      end
    end
    return result
  end
  rawset(vim, '_tbl_add_reverse_lookup_fixed', true)
end

-- Fix for vim.tbl_flatten deprecation (will be removed in Nvim 0.13)
if vim.tbl_flatten and not rawget(vim, '_tbl_flatten_fixed') then
  vim.tbl_flatten = function(tbl)
    -- Use the new recommended approach
    return vim.iter(tbl):flatten():totable()
  end
  rawset(vim, '_tbl_flatten_fixed', true)
end

-- Fix for vim.validate deprecation (will be removed in Nvim 1.0)
-- Simply suppress the deprecation warning without changing behavior
if vim.deprecate then
  local original_deprecate = vim.deprecate
  vim.deprecate = function(what, ...)
    -- Suppress deprecation warnings for known APIs used by plugins
    if what and (
      what:match('vim%.validate') or
      what:match('vim%.str_utfindex') or
      what:match('vim%.tbl_add_reverse_lookup') or
      what:match('vim%.tbl_flatten')
    ) then
      return  -- Suppress the warning
    end
    return original_deprecate(what, ...)
  end
end

return {
  loaded = true,
  version = "1.0.0",
}