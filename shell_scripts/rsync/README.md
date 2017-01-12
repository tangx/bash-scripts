# rsync daemon 安装

## daemon

支持 CentOS, Ubuntu

```bash

# 安装命令
curl -L https://raw.githubusercontent.com/octowhale/bash-scripts/master/shell_scripts/rsync/rsync.install.sh | bash 

# 执行命令
/usr/local/rsync/init.d/rsyncd.sh

```

## client

下载 [rsync windows 客户端](./client/cwrsync_5.3.0_free.zip)

下载 rsync 客户端模板

```

# linux
wget -c -q https://raw.githubusercontent.com/octowhale/bash-scripts/master/shell_scripts/rsync/client/rsync.client.sh

# windows
wget -c -q https://raw.githubusercontent.com/octowhale/bash-scripts/master/shell_scripts/rsync/client/cwrsync.client.cmd

# 密码
wget -c -q https://raw.githubusercontent.com/octowhale/bash-scripts/master/shell_scripts/rsync/client/data3.client.scts

```
