#!/bin/bash -e

if [ ! -f "config/config.yaml" ]
then
    cp config/config_example.yaml config/config.yaml
else
    echo "File config/config.yaml already exists."
fi
