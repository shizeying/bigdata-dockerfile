```dockerfile
 docker run -d -p 9100:9100 mobz/elasticsearch-head:5
```            
```dockerfile
docker build -t elasticsearch-ik-pingyin . && docker run -p 9200:9200 -p 9300:9300 --name es   elasticsearch-ik-pingyin 
```
```java
mvn package -Dmaven.test.skip=true docker:build
```