#!/bin/bash

set -ex

yum install -y wget

function create_dynamo_document () {
  INSTANCE_ID=$1
  AVAILABILITY_ZONE=$2
  INSTANCE_TYPE=$3
  FILENAME="Upload_$1.json"
  printf '{"MachineID": {"S": "%s"}, "AvailabilityZone": {"S": "%s"}, "InstanceType": {"S": "%s"}}\n' "$INSTANCE_ID" "$AVAILABILITY_ZONE" "$INSTANCE_TYPE" > $FILENAME
  aws dynamodb put-item \
              --region $AWS_REGION \
              --table-name ${SYSTEM_NAME}-MachineState \
              --item file://$FILENAME
}

INSTANCE_ID=$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(wget -q -O - http://169.254.169.254/latest/meta-data/placement/availability-zone)
INSTANCE_TYPE=$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-type)
export AWS_REGION=$(wget -q -O - http://169.254.169.254/latest/meta-data/placement/region)

create_dynamo_document "$INSTANCE_ID" "$AVAILABILITY_ZONE" "$INSTANCE_TYPE"
