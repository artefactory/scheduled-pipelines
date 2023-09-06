#!/bin/bash -e

set -e # Exit immediately if a command exits with a non-zero status.
set -a # Mark variables which are modified or created for export.
source secrets/.env


# 1. Create service accounts
gcloud iam service-accounts create ${SERVICE_ACCOUNT_ID_PIPELINE} \
    --description=" SA used by a cloud function to run Vertex pipelines" \
    --display-name="Vertex pipelines runner CF" \
    --project=${PROJECT_ID}

gcloud iam service-accounts create ${SERVICE_ACCOUNT_ID_SCHEDULER} \
    --description="SA used by a cloud scheduler to trigger a cloud function" \
    --display-name="Cloud scheduler SA" \
    --project=${PROJECT_ID}

# 2. Create cloud resources
# 2.1. Create artifact repository for pipeline templates
gcloud artifacts repositories create ${REPOSITORY_NAME} \
    --repository-format=kfp \
    --location=${REGION} \
    --description="Artifact repository used to store Vertex pipelines templates"

# 2.2. Create cloud function to run pipelines
cd "cloud_function"
gcloud functions deploy ${CLOUD_FUNCTION_NAME} \
    --region ${REGION} \
    --no-allow-unauthenticated \
    --entry-point run_vertex_pipeline \
    --service-account ${SERVICE_ACCOUNT_ID_PIPELINE}@${PROJECT_ID}.iam.gserviceaccount.com \
    --runtime python311 \
    --trigger-http \
    --set-env-vars PROJECT_ID=${PROJECT_ID},REGION=${REGION},\
PIPELINE_ROOT_PATH=${PIPELINE_ROOT_PATH},SERVICE_ACCOUNT_ID_PIPELINE=${SERVICE_ACCOUNT_ID_PIPELINE},\
REPOSITORY_NAME=${REPOSITORY_NAME}
cd ..

# 2.3. Create cloud scheduler to trigger cloud function
service_endpoint="${REGION}-aiplatform.googleapis.com"
parent="projects/${PROJECT_ID}/locations/${REGION}"

gcloud scheduler jobs create http schedule_pipeline \
    --uri https://${REGION}-${PROJECT_ID}.cloudfunctions.net/${CLOUD_FUNCTION_NAME} \
    --location ${REGION} \
    --schedule "${CRON_SCHEDULE}" \
    --oidc-service-account-email ${SERVICE_ACCOUNT_ID_SCHEDULER}@${PROJECT_ID}.iam.gserviceaccount.com \
    --message-body-from-file config/cloud_function_params.json

# 3. Grant permissions: create bindings
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID_PIPELINE}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/editor" # TODO: apply least privilege principle

gcloud storage buckets add-iam-policy-binding ${PIPELINE_ROOT_PATH} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID_PIPELINE}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/storage.admin"

gcloud functions add-iam-policy-binding ${CLOUD_FUNCTION_NAME} --region=${REGION} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID_SCHEDULER}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/cloudfunctions.invoker"

gcloud artifacts repositories add-iam-policy-binding ${REPOSITORY_NAME} --location=${REGION} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID_PIPELINE}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/artifactregistry.writer"
