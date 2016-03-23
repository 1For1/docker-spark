#!/usr/bin/env bash
docker pull meyerson/docker-spark
docker run -d -t -P --name spark_master 1for1/docker-spark /app/start-master.sh "$@"