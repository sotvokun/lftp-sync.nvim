local M = {}

M.open = function (site, port, user, passwd, path)
  local _port = string.format('-p %s', port)
  local _user = string.format('-u %s', user)
  if passwd ~= nil or type(passwd) == 'string' or #passwd == 0 then
    _user = _user .. string.format(',%s', passwd)
  end
  return string.format('open %s %s %s', _port, _user, string.format('%s%s', site, path))
end

M.set = function (key, value)
  return string.format('set %s %s', key, value)
end

M.mirror = function (local_, remote, reverse, additional)
  if additional == nil or not vim.tbl_islist(additional) then
    additional = {}
  end
  local default = '--no-perms'
  table.insert(additional, default)
  if reverse then
    table.insert(additional, '-R')
  end
  return string.format('mirror %s %s %s', table.concat(additional, ' '), local_, remote)
end

M.mget = function (remote, additional)
  if additional == nil or not vim.tbl_islist(additional) then
    additional = {}
  end
  local default = '-d'
  table.insert(additional, default)
  return string.format('mget %s %s', table.concat(additional, ' '), remote)
end

M.mput = function (local_, additional)
  if additional == nil or not vim.tbl_islist(additional) then
    additional = {}
  end
  local default = '-d'
  table.insert(additional, default)
  return string.format('mput %s %s', table.concat(additional, ' '), local_)
end

M.default_setup = function ()
  return {
    M.set('net:max-retries', 1)
  }
end

M.build_cmds = function (cmds)
  local lftp_cmds = {}
  if vim.tbl_islist(cmds) then
    lftp_cmds = cmds
  end
  return string.format('lftp -c "%s"', table.concat(lftp_cmds, '; '))
end

return M