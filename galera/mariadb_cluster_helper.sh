#!/bin/bash
GRASTATE_FILE=/var/lib/mysql/grastate.dat
WSREP_NEW_CLUSTER_LOG_FILE=/tmp/wsrep_new_cluster.log
# 如果启动mariadb超过10秒还没返回0，则认为失败了
START_MARIADB_TIMEOUT=10
# 以--wsrep-new-cluster参数启动，超过5次检查，发现仍没有其它节点加入集群，则认为此路不通
SPECIAL_START_WAIT_MAX_COUNT=5
# 得到本机IP
MY_IP=$(grep 'wsrep_node_address' /etc/my.cnf.d/server.cnf | awk -F '=' '{print $2}')
# 杀掉mysqld进程
function kill_mysqld_process() {
    (ps -ef|grep mysqld|grep -v grep|awk '{print $2}'|xargs kill -9) &>/dev/null
}
# 正常启动mariadb
function start_mariadb_normal(){
    # 首先确保safe_to_bootstrap标记为0
    sed -i 's/^safe_to_bootstrap.*$/safe_to_bootstrap: 0/' $GRASTATE_FILE
    timeout $START_MARIADB_TIMEOUT systemctl start mariadb &> /dev/null
    return $?
}
# 以--wsrep-new-cluster参数启动mariadb
function start_mariadb_special(){
    # 首先确保safe_to_bootstrap标记为1
    sed -i 's/^safe_to_bootstrap.*$/safe_to_bootstrap: 1/' $GRASTATE_FILE
    # 以--wsrep-new-cluster参数启动mariadb
    /usr/sbin/mysqld --user=mysql --wsrep-new-cluster &> $WSREP_NEW_CLUSTER_LOG_FILE &
    disown $!
    try_count=0
    # 循环检查
    while [ 1 ]; do
        # 如果超过SPECIAL_START_WAIT_MAX_COUNT次检查，仍没有其它节点加入集群，则认为此路不通，尝试正常启动，跳出循环
        if [ $try_count -gt $SPECIAL_START_WAIT_MAX_COUNT ] ; then
            kill_mysqld_process
            start_mariadb_normal
            return $?
        fi
        new_joined_count=$(grep 'synced with group' /tmp/wsrep_new_cluster.log | grep -v $MY_IP|wc -l)
        exception_count=$(grep 'exception from gcomm, backend must be restarted' $WSREP_NEW_CLUSTER_LOG_FILE | wc -l)
        # 如果新加入的节点数大于0，则认为集群就绪了，可正常启动了，跳出循环
        # 如果运行日志中发现了异常(两个节点都以--wsrep-new-cluster参数启动，其中一个会报错)，则认为此路不通，尝试正常启动，跳出循环
        if [ $new_joined_count -gt 0 ] || [ $exception_count -gt 0 ] ; then
            kill_mysqld_process
            start_mariadb_normal
            return $?
        else
            try_count=$(( $try_count + 1 ))
        fi
        sleep 5
    done
}
# 首先杀掉mysqld进程
kill_mysqld_process
ret=-1
# 如果safe_to_bootstrap标记为1，则立即以--wsrep-new-cluster参数启动
if [ -f $GRASTATE_FILE ]; then
    safe_bootstrap_flag=$(grep 'safe_to_bootstrap' $GRASTATE_FILE | awk -F ': ' '{print $2}')
    if [ $safe_bootstrap_flag -eq 1 ] ; then
        start_mariadb_special
        ret=$?
    else
        start_mariadb_normal
        ret=$?
    fi
else
    start_mariadb_normal
    ret=$?
fi
# 随机地按某种方式启动，直到以某种方式正常启动以止；否则杀掉mysqld进程，随机休息一会儿，重试
while [ $ret -ne 0 ]; do
    kill_mysqld_process
    sleep_time=$(( $RANDOM % 10 ))
    sleep $sleep_time
    choice=$(( $RANDOM % 2 ))
    ret=-1
    if [ $choice -eq 0 ] ; then
        start_mariadb_special
        ret=$?
    else
        start_mariadb_normal
        ret=$?
    fi
done
