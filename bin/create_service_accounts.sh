source config/.env.shared

gcloud iam service-accounts create ${SERVICE_ACCOUNT_ID_PIPELINE} \
    --description=" SA used by a cloud function to run Vertex pipelines" \
    --display-name="Vertex pipelines runner CF" \
    --project=${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID_PIPELINE}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/editor"

# gcloud projects add-iam-policy-binding ${PROJECT_ID} \
#     --member="serviceAccount:${SERVICE_ACCOUNT_ID_PIPELINE}@${PROJECT_ID}.iam.gserviceaccount.com" \
#     --role="roles/aiplatform.user"

# gcloud projects add-iam-policy-binding ${PROJECT_ID} \
#     --member="serviceAccount:${SERVICE_ACCOUNT_ID_PIPELINE}@${PROJECT_ID}.iam.gserviceaccount.com" \
#     --role="roles/storage.admin"

# gcloud projects add-iam-policy-binding ${PROJECT_ID} \
#     --member="serviceAccount:${SERVICE_ACCOUNT_ID_PIPELINE}@${PROJECT_ID}.iam.gserviceaccount.com" \
#     --role="roles/storage.objectCreator"

# gcloud projects add-iam-policy-binding ${PROJECT_ID} \
#     --member="serviceAccount:${SERVICE_ACCOUNT_ID_PIPELINE}@${PROJECT_ID}.iam.gserviceaccount.com" \
#     --role="roles/artifactregistry.reader"

gcloud iam service-accounts create ${SERVICE_ACCOUNT_ID_SCHEDULER} \
    --description=" SA used by a cloud scheduler to trigger a cloud function" \
    --display-name="Cloud scheduler SA" \
    --project=${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID_SCHEDULER}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/cloudfunctions.invoker"

# TODO: refine the permissions

# gsutil iam ch \
# serviceAccount:${SERVICE_ACCOUNT_ID_PIPELINE}@${PROJECT_ID}.iam.gserviceaccount.com:roles/storage.objectCreator,objectViewer \
# gs://pipeline_root_ls
