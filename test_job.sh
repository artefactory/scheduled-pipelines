project="ls-scheduled-pipelines-2c8b"
location="europe-west9"
service_endpoint="${location}-aiplatform.googleapis.com"
parent="projects/${project}/locations/${location}"

curl -X POST \
    -H "Authorization: Bearer $(gcloud auth print-access-token)" \
    -H "Content-Type: application/json; charset=utf-8" \
    -d @request.json \
    "https://${service_endpoint}/v1/${parent}/pipelineJobs?pipelineJobId=test-job-bash-$(date +%Y%m%d-%H%M%S)"
