###
# This docker image is only for local functional test
# For release usage, please visit https://github.com/apache/accumulo-docker
###
FROM airdock/oracle-jdk:1.8

MAINTAINER chpengzh<chpengzh@foxmail.com>

RUN apt-get update
RUN apt-get install -y ssh vim wget && \
    mkdir -p /tmp /opt/bin

# Download resource
ARG zk_src=https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.4.13/zookeeper-3.4.13.tar.gz
ARG hdp_src=https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.9.0/hadoop-2.9.0.tar.gz
ARG ac_src=https://mirrors.tuna.tsinghua.edu.cn/apache/accumulo/1.9.2/accumulo-1.9.2-bin.tar.gz

RUN wget $zk_src && \
    mv zookeeper*.tar.gz zookeeper.tgz && \
    tar xf zookeeper.tgz -C /opt && \
    mv /opt/zookeeper* /opt/zookeeper && \
    rm -rf zookeeper.tgz

RUN wget $hdp_src && \
    mv hadoop*.tar.gz hadoop.tgz && \
    tar xf hadoop.tgz -C /opt && \
    mv /opt/hadoop* /opt/hadoop && \
    rm -rf hadoop.tgz

RUN wget $ac_src && \
    mv accumulo*.tar.gz accumulo.tgz && \
    tar xf accumulo.tgz -C /opt && \
    mv /opt/accumulo* /opt/accumulo && \
    rm -rf accumulo.tgz

ADD ./bin /opt/bin
ADD ./configure /root/configure
ADD ./env/bashrc /tmp/bashrc
ADD ./template/hadoop /opt/hadoop/etc/hadoop
ADD ./template/accumulo /opt/accumulo/conf

# Initiate static global enviornment variable
# Initiate ssh keys and authorization
RUN cat /tmp/bashrc >> /root/.bashrc && \
    ssh-keygen -f /root/.ssh/id_rsa -P "" && \
    cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys

# Dynamic Global enviornment variable
# Those will be configure while starting
ENV LANG="en_US.UTF-8" \
    zookeeper_hosts=localhost \
    zookeeper_id=0 \
    hadoop_master=localhost \
    hadoop_slaves=localhost \
    accumulo_master=localhost \
    accumulo_slaves=localhost \
    accumulo_instance_name=instance \
    accumulo_root_password=root

# Initiate and start ssh service
ENTRYPOINT /root/configure && /bin/bash
