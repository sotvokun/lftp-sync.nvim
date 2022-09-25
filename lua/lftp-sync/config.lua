local M = {}

M.parse = function (content)
  local result = {}
  if not vim.tbl_islist(content) then
    return nil, 'argument is not a list'
  end

  local content_len = #content
  local list_of_key = nil
  for i = 1, content_len, 1 do
    local ln = i
    local str = content[ln]
    if list_of_key == nil then
      -- For comment or key-value pair
      local first_char = string.sub(str, 1, 1)
      if string.find(first_char, '%s') ~= nil then
        return nil, ('key-value pair or comment could not be start with space character at line ' .. ln)
      elseif first_char == '#' then
      else
        local status, _, key, val = string.find(str, '^([a-zA-Z-_]+):%s*([^%s]*)%s*$')
        if status == nil then
          return nil, ('invalid key-value pair syntax at line ' .. ln)
        elseif #val == 0 then
          list_of_key = key
          result = vim.tbl_extend('force', result, {
            [list_of_key] = {}
          })
        elseif #val > 0 then
          result = vim.tbl_extend('force', result, {
            [key] = val
          })
        end
      end
    else
      -- For list item
      local status, _, val = string.find(str,  '^%s+-%s*(.*)$')
      if status ~= nil then
        table.insert(result[list_of_key], vim.trim(val))
      else
        list_of_key = nil
        i = i - 2
      end
    end
  end
  return result, 'ok'
end

M.to_string = function (obj)
  local result = {}
  if type(obj) ~= 'table' then
    return nil, 'argument is not a table'
  end

  for key, value in pairs(obj) do
    if vim.tbl_islist(value) then
      table.insert(result, string.format('%s:', key))
      for _, val in ipairs(value) do
        table.insert(result, string.format('  - %s', val))
      end
    else
      table.insert(result, string.format('%s: %s', key, value))
    end
  end
  return result, 'ok'
end

M.validate = function (obj)
  if type(obj) ~= 'table' then
      return false, 'argument is not a table'
  end

  local necessary_fields = {
    'host',
    'user',
    'remote_path'
  }
  for index, field in ipairs(necessary_fields) do
    if type(obj[field]) == 'nil' then
      return false, ('expect field ' .. field .. ' got nil')
    end
  end
  return true, 'ok'
end

return M