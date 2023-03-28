#!/bin/bash

ACTION=$1

echo $ACTION

if [ "$ACTION" = "install" ]; then
    echo "Installing..."
    git pull origin main
elif [ "$ACTION" = "start" ]; then
    echo "Starting..."
    terraform init
    terraform apply -auto-approve
elif [ "$ACTION" = "stop" ]; then
    echo "Stopping..."
    terraform destroy -auto-approve
elif [ "$ACTION" = "status" ]; then
    echo "Status:"
    res_list=$(terraform state list)
    if [ -z "$res_list" ]; then
        echo "Cluster is not running."
    else
        echo "Cluster is up and running."
        echo Resources: $res_list
    fi
else
    echo "Wrong action! Available actions: install, start, stop, status"
fi