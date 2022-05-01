# lsky-pro-docker
Lsky Pro 兰空图床 docker 镜像，适用于 Linux arm64 和 amd64 架构。

---

我看 GitHub 上有好几个 lsky-pro-docker repo 了（名字类似），虽说是开源了 Dockerfile，但是使用这些资源是不够的（也就是说，你通过这些开源的资源，docker build，虽然镜像能成功创建，但是容器启动后程序无法运行）。所以我新建了此 repo。详细的记录一下 Lsky Pro 镜像应该如何构建。而且简单学习了一下 docker 多架构构建，现分享出来。

docker 镜像构建关键的三个文件

- 000-default.conf
- Dockerfile
- entrypoint.sh

这三个文件在本仓库有。

然后很重要的一点是使用 composer 安装 `composer.json` 指定的依赖。

在构建的机器上安装 `php8.1` 以及 `composer v2.3.5`。在项目根目录执行 `composer install` 安装依赖。

源程序推荐通过 GitHub Release 页面发布的稳定版下载。

多架构构建需要用到 `buildx` 工具，这是一个 docker cli 插件，提供了在一台机器上构建其他平台程序的能力。

镜像构建的过程我写了几篇博客，需要详细了解可阅读

- [斐讯 N1 Debian9 安装 php8.1 和 composer](https://hellodk.cn/post/1032)
- [构建 arm64 架构和 amd64 架构的兰空图床 docker 镜像](https://hellodk.cn/post/1034)
- [Docker 构建多架构镜像实战 构建 amd64 和 arm64 架构的兰空图床镜像](https://hellodk.cn/post/1037)
