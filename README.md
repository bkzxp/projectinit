# 安装软件

 1. Git
 2. VirtualBox - 5.1.32 版本/先前使用的是 5.1.18 版本
 3. Vagrant - 1.8.5 版本， 安装完成后需要注销/重启
 
`\\172.17.15.173\share` 目录里包含以上软件，须保证能在局域网访问该目录，安装开发环境依赖该目录里打包好的虚拟机 `tb7.box`， 如果 IP 或目录变更，需要更改
http://git.we2tu.com/zhangxuepei/projectinit/blob/master/Vagrantfile 
里相应的 IP 和目录，并提交推送到本仓库，另外，仓库须支持从 url 公开访问。

# 初始化开发环境

创建`工作目录`（即所有项目存放的目录），如：`D:/www`。

在任意文件夹空白处右击，选择 `Git Bash`，复制以下命令并执行：

```sh
sh -c "$(curl -fsSL http://git.we2tu.com/zhangxuepei/projectinit/raw/master/sh/init.sh)"
```

根据提示输入`工作目录`，如果目录是 `D:/www` ，请输入 `/d/www` 。

初始化结束后，重新打开 `Git Bash`，运行命令：`tb`

```shell
 # 启动/停止 虚拟机
 tb {start|stop}

 # 重新加载 php 配置
 tb reloadphp

 # 重载 nginx 配置
 tb reloadnginx

 # git pull 项目，多个项目用空格分隔，下同
 tb pull [projects]

 # git checkout 分支名称 项目
 tb checkout {branch} [projects]

 # git status
 tb status [projects]

 # 初始化git设置
 tb gitconfig
```

## 使用示例

```shell
# 启动服务器
tb start

# 一次性拉取 买家、卖家、插件、静态文件 等项目
tb pull buyer seller plugins static service

# 将所有已拉取项目切换到 `dev` 分支
tb checkout dev

# 或者指定几个项目，co 是 checkout 缩略形式
tb co dev buyer seller service
```

## 配置

虚拟机默认 IP 为 `192.168.88.88`，直接访问该 IP ，映射的是 `工作目录`。

配置文件是通过 git 仓库管理的。

php 的默认配置文件是 `/d/projectinit/php.ini/php.ini`，
不要直接修改这个文件，可以在这个目录再单独建一个文件比如 `z.ini`，覆盖默认配置与个性化的配置写在这个文件里，并且避免将个性化的配置同步到仓库里。

nginx 站点的配置文件在 `/d/projectinit/conf` 目录下，建议每个文件配置一个站点。
配置站点时需要注意，`工作目录`对应的是虚拟机里的目录 `/tb` 。

项目绑定的域名在 `工作目录/domain.php` 里，域名可修改，修改后需要运行 `tb reloadnginx` 重载 nginx。


## 更多


```shell
# 在桌面创建两个快捷图标
#  - start.sh 启动虚拟机
#  - 886.sh 关闭虚拟机再倒计时关机
tb desktop

# 登陆虚拟机 ssh
# 虚拟机账号密码：vagrant/vagrant
tb ssh

# 重装虚拟机
tb reset

# 监视 php 错误日志
tb log
```