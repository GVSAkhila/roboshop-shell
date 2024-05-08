#!/bin/bash

NAMES=("mongodb" "redis" "mysql" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
IMAGE_ID="ami-0f3c7d07486cad139"
SECURITY_GROUP_Id="sg-0b9372a5427937029"

for i in "${NAMES[@]}"
do
    if [ "$i" == "mongodb" ] || [ "$i" == "mysql" ]; then
        INSTANCE_TYPE="t3.micro"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    echo "Creating $i instance"

    aws ec2 run-instances \
        --image-id "$IMAGE_ID" \
        --instance-type "$INSTANCE_TYPE" \
        --security-group-ids "$SECURITY_GROUP_Id" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]"
done
