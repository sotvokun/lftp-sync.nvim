local api = vim.api
local fn = vim.fn

local utils = require('lftp-sync.util')
local lftp_sync = require('lftp-sync')

------------------------------------------------------------------------------

api.nvim_set_var('lftp_sync_config_path', '.lftp-sync')
api.nvim_set_var('lftp_sync_print_cmd', false)
api.nvim_set_var('lftp_sync_dry_run', false)

api.nvim_create_user_command(
  'LftpSyncConfig',
  lftp_sync.config_read_or_edit,
  {
    desc = 'Open the configuration file, or create it if file does not exist',
    nargs = 0
})

api.nvim_create_user_command(
  'LftpSyncDownloadAll',
  function ()
    lftp_sync.do_all('download')
  end,
  {
    desc = 'Download all files from remote path',
    nargs = 0
})

api.nvim_create_user_command(
  'LftpSyncUploadAll',
  function ()
    lftp_sync.do_all('upload')
  end,
  {
    desc = 'Upload all files to the remote path',
    nargs = 0
})

api.nvim_create_user_command(
  'LftpSyncDownload',
  function (cmdarg)
    local path = cmdarg.args
    if utils.is_dirpath(path) then
      lftp_sync.do_dir(path, 'download')
    else
      if #path == 0 then
        path = utils.current_file_path()
      end
      lftp_sync.do_file(path, 'download')
    end
  end,
  {
    desc = "Download the file of current buffer, or the specific directory on the remote",
    complete = 'file_in_path',
    nargs = '?'
})

api.nvim_create_user_command(
  'LftpSyncUpload',
  function (cmdarg)
    local path = cmdarg.args
    if utils.is_dirpath(path) then
      lftp_sync.do_dir(path, 'upload')
    else
      if #path == 0 then
        path = utils.current_file_path()
      end
      if fn.filereadable(path) ~= 1 then
        utils.message(string.format([[`%s' file does not exist]], path), true)
        return
      else
        lftp_sync.do_file(path, 'upload')
      end
    end
  end,
  {
    desc = "Upload the file of current buffer, or the specific directory to the remote",
    complete = 'file_in_path',
    nargs = '?'
})