#!/bin/bash -e

echo "
--------------------------------------------
|            Scheduled pipelines           |"
echo "--------------------------------------------"

scheduled_pipeline=$(yq -e '... comments=""' scheduled_pipelines_config.yaml | yq -e '.scheduled_pipelines')
for pipeline in $(echo "${scheduled_pipeline}" | yq 'keys'); do
    cron_schedule=$(echo "${scheduled_pipeline}" | yq ".${pipeline}.cron_schedule")
    if [ "${cron_schedule}" != "null" ]; then
        printf "| %-25s%15s |\n" "${pipeline:0:25}" "${cron_schedule:0:15}"
    fi
done

echo "--------------------------------------------"

echo "
You can now:
- [If you deploy a new pipeline for the first time] Wait about 3 minutes that the Cloud Scheduler job is ready to be used
- Go to the Cloud Scheduler page in the Cloud Console: https://console.cloud.google.com/cloudscheduler?project=${GCP_PROJECT_ID}
- Trigger a force run (see README.md)
- Go to Vertex AI pipelines page in the Cloud Console: https://console.cloud.google.com/vertex-ai/pipelines?project=${GCP_PROJECT_ID}
- See whether the pipelines are running

ℹ️  More detailed instructions & debugging tips are available in the README.md file. ℹ️
"
