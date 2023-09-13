#!/bin/bash -e

region=$(grep 'region' config/config.yaml | sed -n 's/.*region: "\(.*\)"/\1/p')
project_id=$(grep 'id' config/config.yaml | sed -n 's/.*id: "\(.*\)"/\1/p')

echo "Creating Terraform state bucket in project ${project_id} and region ${region}..."
gcloud storage buckets create gs://${project_id}-tf-state \
    --project=${project_id} \
    --location=${region}
