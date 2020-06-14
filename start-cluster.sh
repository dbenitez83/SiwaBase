#!/bin/bash

# create base hadoop cluster docker image
docker build -f docker/base/Dockerfile -t orion/hadoop-cluster-base:latest docker/base

# create master node hadoop cluster docker image
docker build -f docker/master/Dockerfile -t orion/hadoop-cluster-master:latest docker/master

echo "Creating Orion Environmnet..."

# the default node number is 3
N=${1:-3}

docker network create --driver=bridge OrionNetwork &> /dev/null

# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	port=$(( $i + 8042 ))
	docker rm -f hadoop-slave$i &> /dev/null
	echo "startint hadoop-slave$i container..."
	docker run -itd \
	                --net=OrionNetwork \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
					-p $((port)):8042 \
	                orion/hadoop-cluster-base
	i=$(( $i + 1 ))
done 



# starting hadoop master container
docker rm -f hadoop-master &> /dev/null

echo "starting hadoop-master container..."

sudo docker run --hostname=hadoop-master --name hadoop-master --privileged=true -itd -v "/Volumes/Disco Externo/Orion":/src -p 8888:8888 -p 8088:8088 -p 3333:3333 -p 50070:50070 -p 18080:18080 -p 2202:2202 --publish-all=true --network=OrionNetwork  orion/hadoop-cluster-master

# get into hadoop master container
docker exec -it hadoop-master bash

