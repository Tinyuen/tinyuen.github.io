---
title: 如何为已经安装好的 Nginx 添加 SSL 模块
from: 原创
categories:
- 服务端
tags:
- Nginx
date: 2020-03-21 20:36:46
---

一般在默认安装 Nginx 的时候，`http_ssl_module` 模块一般是不会安装的。但是当我们需要在 Nginx 中配置 SSL 的时候，这个模块是必须要安装的。如果配置 SSL 的时候之前没有安装过这个模块，那么不需要重装 Nginx，也是有办法配置这个模块的。接下来就来讲讲怎么在已经安装完的 Nginx 中添加 `http_ssl_module` 模块。
<!--more-->

### 准备工作
在开始前，你需要确保你已经知道你的 Nginx 的一些配置信息。比如安装目录、安装包所在目录。以下是我自己的路径：

- Nginx 版本：**1.12.0**
- Nginx 安装包目录：**/home/gym/data/nginx/nginx-1.12.0**
- Nginx 安装路径：**/usr/local/nginx**

### 检查自己 Nginx 版本以及编译信息

首先运行如下命令查看自己 Nginx 的编译信息。前边的 `/usr/local/nginx` 就是你本地 Nginx **安装目录**
```shell script
/usr/local/nginx/sbin/nginx -V
```
然后你会得到类似如下的信息：
```shell script
nginx version: nginx/1.12.0
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-39) (GCC) 
built with OpenSSL 1.0.2k-fips  26 Jan 2017
TLS SNI support enabled
configure arguments: --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
```
以上信息着重注意：`--prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module` 这个就是我们 Nginx 的编译时候的参数。

因为我已经安装过了 `http_ssl_module` 模块，所以 `configure arguments` 中已经有了。

### 进入 Nginx 安装目录
通过命令进入到自己 Nginx 的安装包的目录，（注意这个目录是你自己机器上的安装目录）
```shell script
cd /home/gym/data/nginx/nginx-1.12.0
```

### 重新编译 Nginx
在 Nginx 的安装目录里面，执行如下命令。`--prefix` 是代表的 Nginx 的安装目录，后面的 `--with-` 是代表的目前的编译参数。以前的参数要记得复制下来，然后在这个参数基础上增加 ssl 模块需要的参数 `--with-http_ssl_module` 
```shell script
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
```

### make 编译
执行 make 命令编译 Nginx，make 完之后在 objs 目录下就多了个 nginx。这个就是我们新的 Nginx 程序。
```shell script
make
```

### 备份原 Nginx，用刚生成的覆盖老的
> 注： 虽然这里的备份不是必须的，但是强烈建议备份。这是个好习惯。

复制原来的 Nginx 作为备份。
```shell script
cp /usr/local/nginx/sbin/nginx /usr/local/nginx/sbin/nginx.bak
```
用上个步骤生成的新的 Nginx 程序覆盖老的。**覆盖之前请先停掉你的 Nginx 服务**。
```shell script
cp objs/nginx /usr/local/nginx/sbin/nginx
```

### 验证配置是否正常
操作完上面的步骤，我们的 Nginx 就已经重新编译好了，并且增加了 `http_ssl_module` 模块。不过还是要验证下配置是否正常。如下：
```shell script
/usr/local/nginx/sbin/nginx -t
```
如果返回的是如下信息，那么恭喜你，说明一切正常：
```shell script
nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
```

### 重启你的 Nginx 
重新启动你的 Nginx，检查配置的 `http_ssl_module` 是否已经生效。
```shell script
cd /usr/local/nginx/sbin
./nginx

# 查看 Nginx 信息
/usr/local/nginx/sbin/nginx -V
```
如果你看到编译参数里面已经增加了 `http_ssl_module` 模块，那就搞定了。
```shell script
nginx version: nginx/1.12.0
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-39) (GCC) 
built with OpenSSL 1.0.2k-fips  26 Jan 2017
TLS SNI support enabled
configure arguments: --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
```

以上，搞定！ 如果帮到你，老板！右下角赏一个？😝
