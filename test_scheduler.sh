project="ls-scheduled-pipelines-2c8b"
location="europe-west9"
location_scheduler="europe-west1"
service_endpoint="${location}-aiplatform.googleapis.com"
parent="projects/${project}/locations/${location}"

gcloud scheduler jobs create http schedule_pipeline \
    --location ${location_scheduler} \
    --schedule "*/3 * * * *" \
    --uri https://${service_endpoint}/v1/${parent}/pipelineJobs?pipelineJobId=test-job-schedule-$(date +%Y%m%d-%H%M%S) \
    --http-method POST \
    # --headers "Content-Type=application/json; charset=utf-8" \
    --message-body-from-file request.json \
    --oauth-service-account-email cloud-scheduler@${project}.iam.gserviceaccount.com \
    # --time-zone "UTC"
    # --headers "Authorization=Bearer ya29.a0AbVbY6OTGhBnsPwnD618cYsZntpkVpR5vdMi0A-DrVADHcyxC8OJP4REN_wTtHpLtrPEypsmiYhmjcW-PiyzhuT16L3IGlUphYP7Tt86GyDqdwE9TfwxKNtDqaNPBBrYSWKZYjHqmTtnBj26TODIU4rMMT2BN0Mzhgv7VAaCgYKAeESARMSFQFWKvPlztJ6fbgw5Seq8E3sdnKuOQ0173" \
