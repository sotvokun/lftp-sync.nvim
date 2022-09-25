local M = {}

M.check = function()
  vim.health.report_start('nvim version report')
  local nvim_ver = vim.version()
  local is_minimum = nvim_ver.major >= 0 and nvim_ver.minor >= 8
  if is_minimum then
    vim.health.report_ok('neovim version >= 0.8.')
  else
    vim.health.report_error('minimum neovim version: 0.8.')
  end

  vim.health.report_start('lftp report')
  if vim.fn.executable('lftp') == 1 then
    vim.health.report_ok('`lftp` executable found.')
  else
    vim.health.report_error('`lftp` executable not found.')
  end
end

return M