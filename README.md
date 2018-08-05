# Apache-Accumulo Docker

This docker image is **only for test**! 

You can use it for self unit test while developing.

For release usage, please visit [apache/accumulo-docker](https://github.com/apache/accumulo-docker)

## Build Images

> Run build instrumentation at project's root path

```
docker build . -t accumulo
```

> If fetch resources fail, try to change download url with:

```
docker build . -t accumulo \
    --build-arg zk_src=${zookeeper_download_url} \
    --build-arg hdp_src=${hadoop_download_url} \
    --build-arg ac_src=${accumulo_download_url}
``` 


## Run accumulo cluster

> Create a docker network for test cluster(if created, ignore it)

```
docker network create cluster --subnet 10.1.1.0/24
```

> Create 3 docker container (1 master and 2 slaves)

```
docker run -dt \
    --network cluster \
    --name docker2 \
    --ip 10.1.1.2 \
    -e zookeeper_id=0 \
    -e zookeeper_hosts=docker2,docker3,docker4 \
    -e hadoop_master=docker2 \
    -e hadoop_slaves=docker3,docker4 \
    -e accumulo_master=docker2 \
    -e accumulo_slaves=docker3,docker4 \
    -e accumulo_instance_name=instance \
    -e accumulo_root_password=root \
    accumulo

docker run -dt \
    --network cluster \
    --name docker3 \
    --ip 10.1.1.3 \
    -e zookeeper_id=1 \
    -e zookeeper_hosts=docker2,docker3,docker4 \
    -e hadoop_master=docker2 \
    -e hadoop_slaves=docker3,docker4 \
    -e accumulo_master=docker2 \
    -e accumulo_slaves=docker3,docker4 \
    accumulo

docker run -dt \
    --network cluster \
    --name docker4 \
    --ip 10.1.1.4 \
    -e zookeeper_id=2 \
    -e zookeeper_hosts=docker2,docker3,docker4 \
    -e hadoop_master=docker2 \
    -e hadoop_slaves=docker3,docker4 \
    -e accumulo_master=docker2 \
    -e accumulo_slaves=docker3,docker4 \
    accumulo
```

> Initiate and start accumulo cluster

```
docker exec -it docker2 /bin/bash /opt/bin/initiate-cluster 
```

> Test shell

```
docker exec -it docker2 /bin/bash

# then execute within docker2's shell, default password root
accumulo shell
```

