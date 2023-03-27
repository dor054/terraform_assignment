#!/bin/bash

ACTION=$1

echo $ACTION

if [ "$ACTION" = "install" ]; then
    echo "Installing..."
elif [ "$ACTION" = "start" ]; then
    echo "Starting..."
elif [ "$ACTION" = "stop" ]; then
    echo "Stopping..."
else
    echo "Wrong action! Available actions: install, start, stop"
fi