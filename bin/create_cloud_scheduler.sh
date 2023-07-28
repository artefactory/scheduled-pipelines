service_endpoint="${REGION}-aiplatform.googleapis.com"
parent="projects/${PROJECT_ID}/locations/${REGION}"

gcloud scheduler jobs create http schedule_pipeline \
    --uri https://${REGION}-${PROJECT_ID}.cloudfunctions.net/${CLOUD_FUNCTION_NAME} \
    --location ${REGION} \
    --schedule "*/5 * * * *" \
    --oidc-service-account-email ${SERVICE_ACCOUNT_ID_SCHEDULER}@${PROJECT_ID}.iam.gserviceaccount.com \
    --message-body-from-file config/cloud_scheduler_params.json
