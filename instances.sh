#!/bin/bash

if [ -z "$2" ]; then

  case $1 in
    launch)
      for component in frontend catalogue cart user shipping payment mysql mongo rabbitmq redis; do
        echo "Launching $component Instance"
        aws ec2 run-instances  --launch-template LaunchTemplateId=lt-04d48af1efaa0fafc --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${component}}]" &>>/tmp/instatances-launch
      done
    ;;
    routes)
      echo Updating routes
      for component in frontend catalogue cart user shipping payment mysql mongo rabbitmq redis; do
        IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=${component} Name=instance-state-name,Values=running | jq '.Reservations[].Instances[].PrivateIpAddress')
        sed -e "s/COMPONENT/${component}/" -e "s/IPADDRESS/${IP}/" record.json >/tmp/${component}.json
        aws route53 change-resource-record-sets --hosted-zone-id Z0776868T2OXFHMTQL3I --change-batch file:///tmp/${component}.json
      done
    ;;
  esac

else
  case $1 in
    launch)
      for component in $2; do
        echo "Launching $component Instance"
        aws ec2 run-instances  --launch-template LaunchTemplateId=lt-04d48af1efaa0fafc --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${component}}]" &>>/tmp/instatances-launch
      done
    ;;
    routes)
      echo Updating routes
      for component in $2; do
        IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=${component} Name=instance-state-name,Values=running | jq '.Reservations[].Instances[].PrivateIpAddress')
        sed -e "s/COMPONENT/${component}/" -e "s/IPADDRESS/${IP}/" record.json >/tmp/${component}.json
        aws route53 change-resource-record-sets --hosted-zone-id Z0776868T2OXFHMTQL3I --change-batch file:///tmp/${component}.json
      done
    ;;
  esac
fi