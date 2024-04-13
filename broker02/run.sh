#!/bin/bash

APP=broker02
IMAGE=ghcr.io/jaranddev/kafka:main
NET=kafka

docker rm -f -v $APP

docker network create $NET || true

docker run -dt --name $APP \
  --mount type=bind,source="$(pwd)"/Storage/Internal/Kafka/Broker02,target=/tmp/kraft-combined-logs \
  -p 29091:29091 \
  -p 29081:29081 \
  -p 9101:9101 \
  -p 9091:9091 \
  --restart unless-stopped \
  --network $NET \
  -e CLUSTER_ID=ODcxMDFlOWU4ZTIzNGEwN2 \
  -e KAFKA_BROKER_ID=2 \
  -e KAFKA_NODE_ID=2 \
  -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT \
  -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://node02.haugerud.network:29091,PLAINTEXT_HOST://node02.haugerud.network:9091 \
  -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
  -e KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0 \
  -e KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1 \
  -e KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 \
  -e KAFKA_JMX_PORT=9101 \
  -e KAFKA_JMX_HOSTNAME=localhost \
  -e KAFKA_PROCESS_ROLES=broker,controller \
  -e KAFKA_CONTROLLER_QUORUM_VOTERS=1@node01.haugerud.network:29081,2@broker02:29081,3@node03.haugerud.network:29081 \
  -e KAFKA_LISTENERS=PLAINTEXT://broker02:29091,CONTROLLER://broker02:29081,PLAINTEXT_HOST://0.0.0.0:9091 \
  -e KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT \
  -e KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER \
  -e KAFKA_LOG_DIRS=/tmp/kraft-combined-logs \
  -e KAFKA_AUTO_CREATE_TOPICS_ENABLE=false \
  $IMAGE
