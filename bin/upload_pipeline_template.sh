#!/bin/bash -e

source secrets/.env
path_to_pipeline_template=$1

echo "Uploading pipeline template to Artifact Registry..."

curl -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -F tags=latest \
    -F content=@${path_to_pipeline_template} \
    https://${REGION}-kfp.pkg.dev/${PROJECT_ID}/${REPOSITORY_NAME}

echo "Pipeline template ${path_to_pipeline_template} successfully uploaded to Artifact Registry!"
