package main

import (
    "github.com/gin-gonic/gin"
    "flag"
    "fmt"
)

var port int

func main() {
    flag.IntVar(&port, "port", 8081, "端口")
    flag.Parse()
    r := gin.Default()
    r.GET("/ping", func(c *gin.Context) {
        c.JSON(200, gin.H{
            "message": "pong",
        })
    })
    r.GET("/info", GetInfo)
    r.GET("/get_upstream", GetUpSteam)
    r.Run(fmt.Sprintf(":%d", port)) // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}

type upstream struct {
    Addr string     `json:"addr"`
    Weight int64    `json:"weight"`
}

func GetUpSteam(c *gin.Context) {
    c.JSON(200, gin.H{
       "message":[]*upstream{&upstream{"127.0.0.1:8001",2}, &upstream{"127.0.0.1:8002",1}},
    })
}

func GetInfo(c *gin.Context) {
    c.JSON(200, gin.H{
        "message": fmt.Sprintf("%d SVR", port),
    })
}