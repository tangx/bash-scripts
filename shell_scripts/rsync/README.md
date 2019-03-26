# rsync daemon 安装

## 常用参数解释

**command** : `rsync -arHlz src dest`

**常用**
+ `-n, --dry-run` 仅测试哪些文件需要传输。
+ `-a, --archive`  归档模式; same as -rlptgoD (no -H)
+ `-r, --recursive`  递归模式
+ `-z, --compress`   传输时压缩文件
+ `--progress` 显示进度

**删除**
+ `--remove-source-files` : 同步后删除源文件。 除非你明确知道在做神恶魔， 否则不要与 `--delete`。
+ `--delete` 删除目标机上本地没有的文件。

**连接**
+ `-l, --links`: 将软连接复制成软连接。
+ `-L, --copy-links`: 使用目标文件替代软连接。
+ `-H, --hard-links` 保留硬连接

**限速**
+ `--bwlimit=KBPS`: 限速 KBytes per second

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
