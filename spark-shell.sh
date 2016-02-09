#!/usr/bin/env bash
docker pull epahomov/docker-spark
docker run -i -t -P --link spark_master:spark_master 1for1/docker-spark /spark-shell.sh "$@"