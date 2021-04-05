#!/bin/bash

if [ -z "$2" ]; then

  case $1 in
    launch)
      for component in frontend catalogue cart user shipping payment mysql mongo rabbitmq redis; do
        echo "Launching $component Spot Instance"
        aws ec2 run-instances  --launch-template LaunchTemplateId=lt-0a3a41bad5ffd4580 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${component}}]" &>>/tmp/instatances-launch
      done
    ;;
    routes)
      echo Updating routes
      for component in frontend catalogue cart user shipping payment mysql mongo rabbitmq redis; do
        IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=${component} Name=instance-state-name,Values=running | jq '.Reservations[].Instances[].PrivateIpAddress')
        sed -e "s/COMPONENT/${component}/" -e "s/IPADDRESS/${IP}/" record.json >/tmp/${component}.json
        aws route53 change-resource-record-sets --hosted-zone-id Z01648193972APZOIN217 --change-batch file:///tmp/${component}.json
      done
    ;;
  esac

else
  case $1 in
    launch)
      for component in $2; do
        echo "Launching $component Spot Instance"
        aws ec2 run-instances  --launch-template LaunchTemplateId=lt-0a3a41bad5ffd4580 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${component}}]" &>>/tmp/instatances-launch
      done
    ;;
    routes)
      echo Updating routes
      for component in $2; do
        IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=${component} Name=instance-state-name,Values=running | jq '.Reservations[].Instances[].PrivateIpAddress')
        sed -e "s/COMPONENT/${component}/" -e "s/IPADDRESS/${IP}/" record.json >/tmp/${component}.json
        aws route53 change-resource-record-sets --hosted-zone-id Z01648193972APZOIN217 --change-batch file:///tmp/${component}.json
      done
    ;;
  esac
fi