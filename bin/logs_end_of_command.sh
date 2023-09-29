#!/bin/bash -e

scheduled_pipelines=$(yq e '... comments=""' scheduled_pipelines_config.yaml | yq -e '.scheduled_pipelines | keys')

echo "
Congrats for scheduling your pipelines! 🎉

Recap of the pipelines scheduled:"
echo "${scheduled_pipelines}"
echo "
You can now:
- [If you deploy a new pipeline for the first time] Wait about 3 minutes that the Cloud Scheduler job is ready to be used
- Go to the Cloud Scheduler page in the Cloud Console: https://console.cloud.google.com/cloudscheduler?project=${GCP_PROJECT_ID}
- Trigger a force run (see README.md)
- Go to Vertex AI pipelines page in the Cloud Console: https://console.cloud.google.com/vertex-ai/pipelines?project=${GCP_PROJECT_ID}
- See whether the pipelines are running

ℹ️  More detailed instructions & debugging tips are available in the README.md file. ℹ️
"
