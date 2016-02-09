
FROM ubuntu:14.04


MAINTAINER 1For1

RUN apt-get -y update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes software-properties-common python-software-properties \
    && apt-add-repository -y ppa:webupd8team/java \
    && apt-get -y update \
    && /bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install oracle-java7-installer oracle-java7-set-default \
    && apt-get -y install curl \
    && apt-get -y update  \
    && apt-get install -y python-numpy python-pandas \
    && apt-get install -y python-pip \
    && apt-get install -y libopenblas-dev liblapack-dev liblapacke-dev libatlas-base-dev libatlas-dev \
    && pip install requests \
    && pip install boto

RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-1.6.0-bin-hadoop2.6.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-1.6.0-bin-hadoop2.6 spark


ADD scripts/start-master.sh /start-master.sh
ADD scripts/start-worker /start-worker.sh
ADD scripts/spark-shell.sh  /spark-shell.sh
ADD scripts/spark-defaults.conf /spark-defaults.conf
ADD scripts/remove_alias.sh /remove_alias.sh


WORKDIR /app/

RUN cp $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh 
RUN /bin/echo "export SPARK_WORKER_INSTANCES=2" >> $SPARK_HOME/conf/spark-env.sh
RUN ln -s $SPARK_HOME/sbin/start-slaves.sh /start-slaves.sh
RUN ln -s $SPARK_HOME/sbin/start-slave.sh /start-slave.sh


ENV SPARK_MASTER_OPTS="-Dspark.driver.port=7001 -Dspark.fileserver.port=7002 -Dspark.broadcast.port=7003 -Dspark.replClassServer.port=7004 -Dspark.blockManager.port=7005 -Dspark.executor.port=7006 -Dspark.ui.port=4040 -Dspark.broadcast.factory=org.apache.spark.broadcast.HttpBroadcastFactory"
ENV SPARK_WORKER_OPTS="-Dspark.driver.port=7001 -Dspark.fileserver.port=7002 -Dspark.broadcast.port=7003 -Dspark.replClassServer.port=7004 -Dspark.blockManager.port=7005 -Dspark.executor.port=7006 -Dspark.ui.port=4040 -Dspark.broadcast.factory=org.apache.spark.broadcast.HttpBroadcastFactory"

ENV SPARK_HOME /usr/local/spark
ENV SPARK_MASTER_PORT 7077
ENV SPARK_MASTER_WEBUI_PORT 8080
ENV SPARK_WORKER_PORT 8888
ENV SPARK_WORKER_WEBUI_PORT 9091

EXPOSE 8080 7077 8888 9091 4040 7001 7002 7003 7004 7005 7006 