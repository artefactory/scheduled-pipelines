#!/bin/bash -e

region=$(grep 'region' scheduled_pipelines_config.yaml | sed -n 's/.*region:[^a-zA-Z0-9-]*\([a-zA-Z0-9-]*\).*/\1/p')
project_id=$(grep 'id' scheduled_pipelines_config.yaml | sed -n 's/.*id:[^a-zA-Z0-9-]*\([a-zA-Z0-9-]*\).*/\1/p')
bucket_name=${project_id}-scheduled-pipelines-f-state

bucket_exists=$(gsutil list -p ${project_id} | grep ${bucket_name} | wc -l)

if [ $bucket_exists -eq 0 ]; then
    echo "Creating Terraform state bucket in project ${project_id} and region ${region}..."
    gcloud storage buckets create gs://${bucket_name} \
        --project=${project_id} \
        --location=${region}
else
    echo "Terraform state bucket already exists in project ${project_id} and region ${region}..."
fi

cat terraform/terraform.tf | BUCKET_PREFIX=$project_id envsubst | tee terraform/terraform.tf 1>/dev/null
