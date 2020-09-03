#!/bin/sh
/usr/sbin/keepalived -n -l -D -f /etc/keepalived/keepalived.conf --dont-fork --log-console &
haproxy -f /usr/local/etc/haproxy/haproxy.cfg
