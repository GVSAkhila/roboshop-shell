#!/bin/bash

NAMES=("mongodb" "redis" "mysql" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
INSTANCE_TYPE=""
IMAGE_ID=ami-0f3c7d07486cad139
SECURITY_GROUP_Id=sg-0b9372a5427937029

#if mysql and monodb instance type is t3.micro

for i in "${NAMES[@]}"
do
if [ $i== "mongodb" || $i== "mysql" ]
then
INSTANCE_TYPE="t3.micro"
else
INSTANCE_TYPE="t2.micro"
echo "NAMES are :  $i"
fi
echo "creating $i instance"

aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_Id  'ResourceType=instance,Tags=[{Key=Name,Value=MyInstance},{Key=Environment,Value=$i}]'
done
