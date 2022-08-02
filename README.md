# lsky-pro-docker
Lsky Pro 兰空图床 docker 镜像，适用于 Linux arm64 和 amd64 架构。镜像地址: https://hub.docker.com/r/dko0/lsky-pro

镜像使用

```
# 拉取镜像
# docker pull dko0/lsky-pro:2.0.4

# 启动容器
# docker run -d --name=lsky-pro --restart=always -v /path/to/mount/lsky-pro-data:/var/www/html -p 7791:80 dko0/lsky-pro:2.0.4
```

---

我看 GitHub 上有好几个 lsky-pro-docker repo 了（名字类似），虽说是开源了 Dockerfile，但是使用这些资源是不够的（也就是说，你通过这些开源的资源，docker build，虽然镜像能成功创建，但是容器启动后程序无法运行）。所以我新建了此 repo。详细的记录一下 Lsky Pro 镜像应该如何构建。而且简单学习了一下 docker 多架构构建，现分享出来。

本镜像构建关键的三个文件

- 000-default.conf
- Dockerfile
- entrypoint.sh

这三个文件在本仓库有。

然后很重要的一点是使用 composer 安装 `composer.json` 指定的依赖。

在构建的机器上安装 `php8.1` 以及 `composer v2.3.5` 环境。在项目根目录执行 `composer install` 安装依赖。

源程序推荐通过 GitHub Release 页面发布的最新稳定版下载。

多架构构建需要用到 `buildx` 工具，这是一个 docker cli 插件，提供了在一台机器上构建其他平台程序的能力。

镜像构建的过程我写了几篇博客，需要详细了解可阅读

- [斐讯 N1 Debian9 安装 php8.1 和 composer](https://hellodk.cn/post/1032)
- [构建 arm64 架构和 amd64 架构的兰空图床 docker 镜像](https://hellodk.cn/post/1034)
- [Docker 构建多架构镜像实战 构建 amd64 和 arm64 架构的兰空图床镜像](https://hellodk.cn/post/1037)

---

有任何问题，请在此仓库创建 issue 交流，感谢使用！

贴一个 nginx 反向代理的配置，支持 80 端口 301 跳转到 443 端口，并且使用 ssl 证书。建议将以下内容（请自行修改域名、证书等内容）保存至 `/etc/nginx/vhost/lsky-pro.conf` 或是 `/etc/nginx/sites-enabled/lsky-pro.conf`

```
server {
        listen 80;
        listen [::]:80;

        server_name img.example.com;

        location / {
                return 301 https://img.example.com$request_uri;
        }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name img.example.com;
    server_tokens off;
    root /path/to/mount/lsky-pro-data/public;

    ssl_certificate    /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key    /etc/letsencrypt/live/example.com/privkey.pem;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256!aNULL:!MD5:!RC4:!DHE;
    ssl_prefer_server_ciphers on;
    ssl_session_timeout 10m;

    index index.php;

    charset utf-8;

    error_log  /var/log/nginx/lskypro.error.log error;

    location / {
            proxy_pass http://127.0.0.1:7791;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header REMOTE-HOST $remote_addr;
    }
}
```

保存后执行

```
# nginx -t
# nginx -s reload
```

如果没有任何报错，那么恭喜，你的图床 https://img.example.com 已经可用了。
