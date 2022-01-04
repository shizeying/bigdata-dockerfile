mkdir /opt/zookeeper-3.4.5-cdh5.16.1/{data,logs} && echo "1" > /opt/zookeeper-3.4.5-cdh5.16.1/data/myid


for i in {1..100} do echo $i done

for i in {1..4}; do  ssh -t  bigdata-slave$i "ln -s /opt/hadoop-2.6.0-cdh5.16.1/etc/hadoop/hdfs-site.xml /opt/hbase-1.2.0-cdh5.16.1/conf/hdfs-site.xml"; done
for i in {1..4}; do  ssh -t  bigdata-slave$i "ln -s /opt/hadoop-2.6.0-cdh5.16.1/etc/hadoop/core-site.xml /opt/hbase-1.2.0-cdh5.16.1/conf/core-site.xml"; done






ln -s /opt/hadoop-2.6.0-cdh5.16.1/etc/hadoop/hdfs-site.xml /opt/hbase-1.2.0-cdh5.16.1/conf/hdfs-site.xml
ln -s /opt/hadoop-2.6.0-cdh5.16.1/etc/hadoop/core-site.xml /opt/hbase-1.2.0-cdh5.16.1/conf/core-site.xml
