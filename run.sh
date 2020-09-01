#!/bin/sh

image=mykong:1.2.1
enviroments="
-e KONG_PREFIX=/usr/local/kong
-e KONG_DATABASE=postgres
-e KONG_PG_HOST=10.60.118.77
-e KONG_PG_PORT=5432
-e KONG_PG_USER=kong
-e KONG_PG_PASSWORD=kong
-e KONG_PG_DATABASE=kong_db
-e KONG_TRUSTED_IPS=0.0.0.0/0,::/0
-e KONG_REAL_IP_HEADER=X-Forwarded-For
-e KONG_PROXY_LISTEN='0.0.0.0:8000, 0.0.0.0:8443 ssl
-e KONG_ADMIN_LISTEN='0.0.0.0:8001, 0.0.0.0:8444 ssl
"

# 初始化数据库
function init(){
docker run -it --rm $enviroments \
$image  kong migrations bootstrap
}


# 启动kong
function run(){
docker run -it --rm $enviroments \
-p 8000:8000 -p 8443:8443 -p 8001:8001 -p 8444:8444    \
$image
}

case $1 in
"init")
	init;;
"run")
	run;;
* )
	echo "run/init"
esac
