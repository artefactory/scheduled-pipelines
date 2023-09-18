#!/bin/bash -e

region=$(grep 'region' config/scheduled_pipelines_config.yaml | sed -n 's/.*region: "\(.*\)"/\1/p')
project_id=$(grep 'id' config/scheduled_pipelines_config.yaml | sed -n 's/.*id: "\(.*\)"/\1/p')

echo "Creating Terraform state bucket in project ${project_id} and region ${region}..."
gcloud storage buckets create gs://${project_id}-scheduled-pipelines-tf-state \
    --project=${project_id} \
    --location=${region}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux detected"
    sed -i "s/{PLACEHOLDER_FOR_SED}/$project_id/g" terraform/terraform.tf # Syntax for Linux
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "MacOS detected"
    sed -i '' "s/{PLACEHOLDER_FOR_SED}/$project_id/g" terraform/terraform.tf # Syntax for MacOS, see https://github.com/danielebailo/couchdb-dump/issues/35#issuecomment-148106536
else
    echo "OS not supported. Replace {PLACEHOLDER_FOR_SED} in terraform/terraform.tf with ${project_id} manually."
    exit 1
fi
