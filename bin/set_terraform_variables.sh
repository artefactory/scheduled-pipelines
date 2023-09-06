#!/bin/bash -e

source secrets/.env

export TF_VAR_project_id=$PROJECT_ID
export TF_VAR_region=$REGION
export TF_VAR_pipeline_root_path=$PIPELINE_ROOT_PATH
export TF_VAR_service_account_id_pipeline=$SERVICE_ACCOUNT_ID_PIPELINE
export TF_VAR_service_account_id_scheduler=$SERVICE_ACCOUNT_ID_SCHEDULER
export TF_VAR_repository_name=$REPOSITORY_NAME
export TF_VAR_cloud_function_name=$CLOUD_FUNCTION_NAME
export TF_VAR_cron_schedule=$CRON_SCHEDULE
