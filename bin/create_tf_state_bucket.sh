#!/bin/bash -e

region=$(grep 'region' config/scheduled_pipelines_config | sed -n 's/.*region: "\(.*\)"/\1/p')
project_id=$(grep 'id' config/scheduled_pipelines_config | sed -n 's/.*id: "\(.*\)"/\1/p')

echo "Creating Terraform state bucket in project ${project_id} and region ${region}..."
gcloud storage buckets create gs://${project_id}-tf-state \
    --project=${project_id} \
    --location=${region}


sed -i '' "s/{PLACEHOLDER_FOR_SED}/$project_id/g" terraform/terraform.tf # Syntax for MacOS, see https://github.com/danielebailo/couchdb-dump/issues/35#issuecomment-148106536
