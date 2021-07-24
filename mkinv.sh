#!/bin/bash

> /tmp/inv
for component in frontend catalogue cart user shipping payment mysql mongo redis rabbitmq; do
  IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=${component} Name=instance-state-name,Values=running | jq '.Reservations[].Instances[].PublicIpAddress' |xargs)
  if [ -n "${IP}" ]; then
    echo $IP component=${component} ansible_user=root ansible_password=DevOps321 >> /tmp/inv
  fi
done