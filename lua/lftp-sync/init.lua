local api = vim.api
local fn = vim.fn

local utils = require('lftp-sync.util')
local lftp = require('lftp-sync.lftp-wrapper')

local function execute_with_notify(cmd)
  if utils.do_dry_run() then
    utils.message(cmd)
    return
  end
  if utils.do_print_cmd() then
    utils.message(cmd)
  end
  local msg = fn.system(cmd)
  if #msg == 0 then
    utils.message('ok')
  else
    utils.message(msg, true)
  end
end

local M = {}

M.config_read_or_edit = function ()
  if not utils.config_readable() then
    utils.create_default_config()
  end
  local path = api.nvim_get_var('lftp_sync_config_path')
  vim.cmd(string.format('edit %s', path))
end

M.do_all = function (type)
  if type ~= 'upload' and type ~= 'download' then
    utils.message('INNER ERROR: unknown type for do_all', true)
    return
  end
  local config, config_msg = utils.read_config()
  if config == nil then
    utils.message(config_msg, true)
    return
  end
  local cmd = lftp.build_cmds({
    lftp.set('net:max-retries', 1),
    lftp.open(config.host, config.port or 21, config.user, config.passwd, config.remote_path),
    lftp.mirror('.', '.', type == 'upload')
  })
  utils.message(type .. 'ing all')
  execute_with_notify(cmd)
end

M.do_dir = function (dir, type)
  if type ~= 'upload' and type ~= 'download' then
    utils.message('INNER ERROR: unknown type for do_all', true)
    return
  end
  local config, config_msg = utils.read_config()
  if config == nil then
    utils.message(config_msg, true)
    return
  end
  local normalized_path = vim.fs.normalize(dir)
  local cmd = lftp.build_cmds({
    lftp.set('net:max-retries', 1),
    lftp.open(config.host, config.port or 21, config.user, config.passwd, config.remote_path),
    lftp.mirror(normalized_path, normalized_path, type == 'upload')
  })
  utils.message(type .. 'ing, path: ' .. normalized_path)
  execute_with_notify(cmd)
end

M.do_file = function (file, type)
  if type ~= 'upload' and type ~= 'download' then
    utils.message('INNER ERROR: unknown type for do_all', true)
    return
  end
  local config, config_msg = utils.read_config()
  if config == nil then
    utils.message(config_msg, true)
    return
  end
  local normalized_path = vim.fs.normalize(file)
  local cmd_list = {
    lftp.set('net:max-retries', 1),
    lftp.open(config.host, config.port or 21, config.user, config.passwd, config.remote_path)
  }
  if type == 'upload' then
    table.insert(cmd_list, lftp.mput(normalized_path))
  elseif type == 'download' then
    table.insert(cmd_list, lftp.mget(normalized_path))
  end

  local cmd = lftp.build_cmds(cmd_list)
  utils.message(type .. 'ing, path: ' .. normalized_path)
  execute_with_notify(cmd)
end

return M