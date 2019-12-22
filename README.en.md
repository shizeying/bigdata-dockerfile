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
docker build -t hadoop . && docker run -p 50070:50070 -p 60010:60010 -p 8081:8081 -p 2181:2181 -p 19888:19888 -p 8020:8020 -p 9092:9092 -p 9093:9093 -p 9001:9000 -p 8088:8088 --name hadoop -h hadoop   hadoop 
```

切记:hostname必须指定为hadoop,此种方式搭建的为单节点



