#!/bin/bash

mkdir /home/pi/kafka-storage/storage-broker
cp -r /home/pi/kafka/storage-backup/broker03 /home/pi/kafka-storage/storage-broker

docker network create kafka || true

docker run -dt --name broker \
  -p 29091:29091 \
  -p 29081:29081 \
  -p 9101:9101 \
  -p 9091:9091 \
  --network kafka \
  -e KAFKA_BROKER_ID=3 \
  -e KAFKA_NODE_ID=3 \
  -e KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT,PLAINTEXT_HOST:PLAINTEXT \
  -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://broker:29091,PLAINTEXT_HOST://192.168.0.249:9091 \
  -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
  -e KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0 \
  -e KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1 \
  -e KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 \
  -e KAFKA_JMX_PORT=9101 \
  -e KAFKA_JMX_HOSTNAME=localhost \
  -e KAFKA_PROCESS_ROLES=broker,controller \
  -e KAFKA_CONTROLLER_QUORUM_VOTERS=1@192.168.0.247:29081,2@192.168.0.248:29081,3@broker:29081 \
  -e KAFKA_LISTENERS=PLAINTEXT://broker:29091,CONTROLLER://broker:29081,PLAINTEXT_HOST://0.0.0.0:9091 \
  -e KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT \
  -e KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER \
  -e KAFKA_LOG_DIRS=/tmp/kraft-combined-logs \
  -e KAFKA_AUTO_CREATE_TOPICS_ENABLE=false \
  -v /home/pi/kafka-storage/storage-broker:/tmp/kraft-combined-logs \
  ghcr.io/jaranddev/kafka:main
