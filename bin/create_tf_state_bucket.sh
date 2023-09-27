#!/bin/bash -e

region=$(yq -e .project.region scheduled_pipelines_config.yaml)
project_id=$(yq -e .project.id scheduled_pipelines_config.yaml)
bucket_name=${project_id}-scheduled-pipelines-tf-state

bucket_exists=$(gsutil list -p ${project_id} | grep ${bucket_name} | wc -l)

if [ $bucket_exists -eq 0 ]; then
    echo "Creating Terraform state bucket in project ${project_id} and region ${region}..."
    gcloud storage buckets create gs://${bucket_name} \
        --project=${project_id} \
        --location=${region}
else
    echo "Terraform state bucket already exists in project ${project_id} and region ${region}..."
fi

cat terraform/terraform.tf | BUCKET_PREFIX=$project_id envsubst > temp.tf && mv temp.tf terraform/terraform.tf
