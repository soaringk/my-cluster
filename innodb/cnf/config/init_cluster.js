shell.connect('root@localhost:3306', '123456')
dba.createCluster('mycluster', { 'localAddress': '172.18.0.1' })
var cluster = dba.getCluster('mycluster')
cluster.addInstance('root@172.18.0.2:3306', { 'localAddress': '172.18.0.2', 'password': '123456' })
cluster.addInstance('root@172.18.0.3:3306', { 'localAddress': '172.18.0.3', 'password': '123456' })
