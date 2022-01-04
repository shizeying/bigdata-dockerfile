

&emsp;如果使用此项目,请通过以下链接下载tar包,这里重点说明下,有以下包需要自己编译修改,这个前提是你需要对该项目的文件进行升级版本,那么就需要做到修改.

&emsp;如果你不需要更改,只是自己玩的话可以通过以下链接下载tar包:

```
链接: https://pan.baidu.com/s/1iXs69xwAFU9M2SoP9U_22Q 提取码: 8kvg 复制这段内容后打开百度网盘手机App，操作更方便哦
```

&emsp;需要编译的包如下:

```
flink 
kafka
(这两个是基于2.6.0-cdh-5.14.2进行编译,需要更改的请自行编译)
elasticsearch-analysis-hanlp-6.8.4.zip(需要自行编译)
elasticsearch-analysis-pinyin-6.8.4.zip(因为支持了汉字+拼音的分词插件,所以需要自行编译)


```

具体拼音分词的编译请看这个博客:

[拼音+汉字混合搜索](https://blog.csdn.net/weixin_40334693/article/details/103438471)

## apline

```dockerfile
docker build -t alpine-all .
```

## yili/jdk8 

```
docker build -t yili/jdk8 .
```

## jdk-scala

```
docker build -t jdk-scala .
```

## hadoop

```dockerfile
docker build -t hadoop .
&& docker run
-p 50070:50070 -p 60010:60010 -p 8081:8081 -p 2181:2181 -p 19888:19888 -p 8020:8020 -p 9092:9092 -p 9000:9000 -p 8088:8088 -p 16201:16201 -p 16301:16301 -p 8085:8085 -p 9095:9095
--name hadoop
-h hadoop
-e ADVERTISED_HOST=127.0.0.1 -e ADVERTISED_PORT=9092
--restart always
--network bigdata
--ip 172.22.16.3
hadoop 
```

切记:hostname必须指定为hadoop,此种方式搭建的为单节点



