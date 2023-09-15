#!/bin/bash -e

if [ ! -f "config/scheduled_pipelines_config" ]
then
    cp config/scheduled_pipelines_config_example.yaml config/scheduled_pipelines_config
else
    echo "File config/scheduled_pipelines_config already exists."
fi
