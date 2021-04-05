#!/bin/bash

>inventory
for component in frontend catalogue cart user shipping payment mysql mongo rabbitmq redis; do
  IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=${component} Name=instance-state-name,Values=running | jq '.Reservations[].Instances[].PrivateIpAddress' |xargs)
  if [ -n "${IP}" ]; then
    echo $IP component=${component} ansible_user=centos ansible_password=DevOps321 >>inventory
  fi
done
