PROJECT_ID=ls-scheduled-pipelines-2c8b

gcloud iam service-accounts create cloud-scheduler \
    --description="Cloud scheduler SA (used to run Vertex pipelines)" \
    --display-name="Cloud Scheduler Vertex pipelines" \
    --project=${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:cloud-scheduler@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/aiplatform.user"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:cloud-scheduler@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/storage.objectViewer"

gsutil iam ch \
serviceAccount:cloud-scheduler@${PROJECT_ID}.iam.gserviceaccount.com:roles/storage.objectCreator,objectViewer \
gs://pipeline_root_ls
