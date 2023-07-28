source config/.env.shared

set -e

# # Create service accounts
gcloud iam service-accounts create ${SERVICE_ACCOUNT_ID_PIPELINE} \
    --description=" SA used by a cloud function to run Vertex pipelines" \
    --display-name="Vertex pipelines runner CF" \
    --project=${PROJECT_ID}

gcloud iam service-accounts create ${SERVICE_ACCOUNT_ID_SCHEDULER} \
    --description="SA used by a cloud scheduler to trigger a cloud function" \
    --display-name="Cloud scheduler SA" \
    --project=${PROJECT_ID}

# # Create cloud resources
bash bin/create_bucket.sh
bash bin/create_artifact_registry.sh
bash bin/deploy_cloud_function.sh
bash bin/create_cloud_scheduler.sh

# Grant permissions
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
