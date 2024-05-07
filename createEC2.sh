#!/bin/bash

NAMES=("mongodb" "redis" "mysql" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${NAMES[@]}"
do
echo "NAMES are :  $i"
done
