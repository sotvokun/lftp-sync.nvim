local api = vim.api
local fn = vim.fn

local config = require('lftp-sync.config')

local M = {}

M.create_default_config = function ()
  local path = api.nvim_get_var('lftp_sync_config_path')
  fn.mkdir(vim.fs.dirname(path), 'p')
  local default_config = {
    host = 'localhost',
    port = 21,
    user = 'anonymous',
    passwd = '***',
    remote_path = '/'
  }
  fn.writefile(config.to_string(default_config), path)
end

M.config_readable = function ()
  local path = api.nvim_get_var('lftp_sync_config_path')
  return vim.fn.filereadable(path) == 1
end

M.message = function (msg, error)
  local level = vim.log.levels.INFO
  if error then
    level = vim.log.levels.ERROR
  end
  api.nvim_notify(string.format('[lftp-sync] %s', msg), level, {})
end

M.read_config = function ()
  if not M.config_readable() then
    return nil, 'config file does not exist'
  end
  local path = api.nvim_get_var('lftp_sync_config_path')
  local config_result, config_result_msg = config.parse(fn.readfile(path))
  if config_result == nil then
    return nil, config_result_msg
  end
  local valid_result, valid_result_msg = config.validate(config_result)
  if valid_result == nil then
    return nil, valid_result_msg
  end
  --#region fill the default config
  config_result.port = config_result.port or 21
  config_result.settings = vim.list_extend({
    'net:max-retries 1',
    'net:timeout 10'
  }, config_result.settings or {})
  --#endregion
  return config_result, 'ok'
end

M.do_print_cmd = function ()
  return api.nvim_get_var('lftp_sync_print_cmd')
end

M.do_dry_run = function ()
  return api.nvim_get_var('lftp_sync_dry_run')
end

M.is_dirpath = function (path)
  local last_char = string.sub(path, #path, #path)
  return last_char == '/' or last_char == '\\'
end

M.current_file_path = function (bufnr)
  return fn.expand('%:.')
end

return M