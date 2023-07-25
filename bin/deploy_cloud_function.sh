PROJECT_ID="ls-scheduled-pipelines-2c8b"
REGION="europe-west1"
PIPELINE_ROOT_PATH="gs://pipeline_root_ls"
SERVICE_ACCOUNT="pipeline-runner@ls-scheduled-pipelines-2c8b.iam.gserviceaccount.com"
cloud_function_dir="cloud_function"

cd ${cloud_function_dir}

gcloud functions deploy run_pipeline \
    --region ${REGION} \
    --no-allow-unauthenticated \
    --entry-point run_pipeline \
    --service-account ${SERVICE_ACCOUNT} \
    --runtime python311 \
    --trigger-http \
    --set-env-vars PROJECT_ID=${PROJECT_ID},REGION=${REGION},PIPELINE_ROOT_PATH=${PIPELINE_ROOT_PATH},SERVICE_ACCOUNT=${SERVICE_ACCOUNT}
