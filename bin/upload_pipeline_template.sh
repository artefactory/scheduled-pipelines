#!/bin/bash -e

path_to_pipeline_template=$1

region=$(grep 'region' config/config.yaml | sed -n 's/.*region: "\(.*\)"/\1/p')
project_id=$(grep 'id' config/config.yaml | sed -n 's/.*id: "\(.*\)"/\1/p')
repository_name=$(grep 'repository_name' config/config.yaml | sed -n 's/.*repository_name: "\(.*\)"/\1/p')

echo "Uploading pipeline template to Artifact Registry (${region}-kfp.pkg.dev/${project_id}/${repository_name})..."

curl -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -F tags=latest \
    -F content=@${path_to_pipeline_template} \
    https://${region}-kfp.pkg.dev/${project_id}/${repository_name}

echo "Pipeline template ${path_to_pipeline_template} successfully uploaded to Artifact Registry!"
