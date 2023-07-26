source config/.env.shared

gcloud artifacts repositories create ${REPOSITORY_NAME} \
    --repository-format=kfp \
    --location=${REGION} \
    --description="Artifact repository used to store Vertex pipelines templates"
