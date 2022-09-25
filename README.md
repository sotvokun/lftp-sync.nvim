# LFTP Sync Plugin for Neovim
Sync buffer (upload or download) with remote via LFTP.

## Requirements
- neovim (version >= 0.8)
- lftp

## Install
Use your favorite plugin manager to install it.
```lua
-- packer
use {'sotvokun/lftp-sync.nvim'}
```

## Usage
To make the FTP workflow comfortable, this plugin inspired by VSCode extension [SFTP](https://marketplace.visualstudio.com/items?itemName=Natizyskunk.sftp) and Sublime Text package [FTPSync](https://packagecontrol.io/packages/FTPSync).

### Configure
Use `:LftpSyncConfig` to open the configuration file, or create it if it does not exist. The configuration file path is defined in `g:lftp_sync_config_path`; lftp-sync will check the file whether readable to make the "sync" commands useable.

More about the configuration file, you could read document `lftp-sync-configuration`.

### Download/Upload
When your configuring is done, the best practice is using `:LftpSyncDownloadAll` to download the whole project to the local.

Then edit your files, you can choose `:LftpSyncUploadAll` to upload whole project into remote, or `:LftpSyncUpload` to upload the file which you are editing to remote.

`:LftpSyncDownload` and `:LftpSyncUpload` can take one argument that which file or directory, to download from remote, or to upload to remote.

More about the commands, you could read document `lftp-sync-commands`

## Contribution
Using FTP to synchronize the working progression is a weird behaviour in the modern development work. If you are unfortunate as me, working in a company that using the unpopular workflow, I am very glad to accept your pull request.