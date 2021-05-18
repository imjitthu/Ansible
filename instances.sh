#!/bin/bash

if [ -z "$2" ]; then

  case $1 in
    launch)
      for component in frontend catalogue cart user shipping payment mysql mongo redis rabbitmq; do
        echo "Launching $component Spot Instance"
        aws ec2 run-instances  --launch-template LaunchTemplateId=lt-0ab50da5bc0120a59 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${component}}]" &>>/tmp/instatances-launch
      done
    ;;
    routes)
      echo Updating routes
      for component in frontend catalogue cart user shipping payment mysql mongo redis rabbitmq; do
        IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=${component} Name=instance-state-name,Values=running | jq '.Reservations[].Instances[].PrivateIpAddress')
        sed -e "s/COMPONENT/${component}/" -e "s/IPADDRESS/${IP}/" record.json >/tmp/${component}.json
        aws route53 change-resource-record-sets --hosted-zone-id Z077254017HKF6MBGS2JG --change-batch file:///tmp/${component}.json
      done
    ;;
  esac

else
  case $1 in
    launch)
      for component in $2; do
        echo "Launching $component Spot Instance"
        aws ec2 run-instances  --launch-template LaunchTemplateId=lt-0ab50da5bc0120a59 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${component}}]" &>>/tmp/instatances-launch
      done
    ;;
    routes)
      echo Updating routes
      for component in $2; do
        IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=${component} Name=instance-state-name,Values=running | jq '.Reservations[].Instances[].PrivateIpAddress')
        sed -e "s/COMPONENT/${component}/" -e "s/IPADDRESS/${IP}/" record.json >/tmp/${component}.json
        aws route53 change-resource-record-sets --hosted-zone-id Z077254017HKF6MBGS2JG --change-batch file:///tmp/${component}.json
      done
    ;;
  esac
fi