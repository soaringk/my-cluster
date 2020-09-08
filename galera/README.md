# 简介

HAproxy 实现对集群的负载均衡和错误检测，keepalived 维持对 HAproxy 的高可用。终端只使用 keepalived 服务暴露出来的 vip 进行访问，屏蔽集群的细节。

网络拓扑图如下：

![topology](http://s3.51cto.com/wyfs02/M01/8C/0A/wKiom1hfysqALMaCAACFtpfI3dc181.png)

# 注意要点

* HAproxy 监听 galera 集群服务需要使用 tcp 模式
* HAproxy 错误检测脚本使用了外部命令（external-check），具体配置参考官方文档
* 如果所有的 galera 集群节点都失效了，可能需要人工干预恢复，仅靠脚本还不够。

# 参考

[高可用之keepalived&haproxy](https://jeremyxu2010.github.io/2018/02/高可用之keepalivedhaproxy)
[MariaDB Galera Cluster部署实战](https://jeremyxu2010.github.io/2018/02/mariadb-galera-cluster部署实战/)
