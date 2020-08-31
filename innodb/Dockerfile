FROM Centos:7

COPY cnf/my.cnf /etc/my.cnf
COPY cnf/hosts /etc/hosts
COPY cnf/config /opt
ENV LANG=en_US.utf8
RUN yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm \
    && yum-config-manager --disable mysql80-community \
    && yum-config-manager --enable mysql57-community \
    && yum install -y mysql-community-server mysql-shell mysql-router

RUN mysqlsh --no-password --js --file=/opt/config_local_instance.js
RUN mysqlsh --no-password --js --file=/opt/init_cluster.js

RUN mysqlrouter --bootstrap root:R00T%40mysql@172.18.0.1:3306 --user=mysqlrouter
