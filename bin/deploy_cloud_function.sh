cloud_function_dir="cloud_function"

cd ${cloud_function_dir}

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
