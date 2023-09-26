#!/bin/bash -e

region=$(grep 'region' scheduled_pipelines_config.yaml | sed -n 's/.*region:[^a-zA-Z0-9-]*\([a-zA-Z0-9-]*\).*/\1/p')
project_id=$(grep 'id' scheduled_pipelines_config.yaml | sed -n 's/.*id:[^a-zA-Z0-9-]*\([a-zA-Z0-9-]*\).*/\1/p')

echo "Creating Terraform state bucket in project ${project_id} and region ${region}..."
gcloud storage buckets create gs://${project_id}-scheduled-pipelines-tf-state \
    --project=${project_id} \
    --location=${region}

cat terraform/terraform.tf | BUCKET_PREFIX=$project_id envsubst | tee terraform/terraform.tf >/dev/null
