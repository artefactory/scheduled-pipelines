#!/bin/bash -e

project_id=$(grep 'id' config/config.yaml | sed -n 's/.*id: "\(.*\)"/\1/p')

echo "Enabling services in project ${project_id}..."

gcloud services enable \
    cloudscheduler.googleapis.com \
    cloudfunctions.googleapis.com \
    cloudbuild.googleapis.com \
    artifactregistry.googleapis.com \
    storage-component.googleapis.com \
    aiplatform.googleapis.com \
    --project=${project_id}
