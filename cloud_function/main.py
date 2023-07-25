"""Cloud function to run a Vertex pipeline."""
import os

import flask
import functions_framework
from google.cloud import aiplatform

PROJECT_ID = os.getenv("PROJECT_ID")
REGION = os.getenv("REGION")
PIPELINE_ROOT_PATH = os.getenv("PIPELINE_ROOT_PATH")
SERVICE_ACCOUNT = os.getenv("SERVICE_ACCOUNT")


@functions_framework.http
def run_pipeline(request: flask.request) -> str:  # noqa: ARG001
    """Run Vertex pipeline."""
    aiplatform.init(
        project=PROJECT_ID,
        location=REGION,
    )

    job = aiplatform.PipelineJob(
        display_name="hello-world-cloud-function-pipeline",
        template_path="https://europe-west9-kfp.pkg.dev/ls-scheduled-pipelines-2c8b/pipelines/hello-world-pipeline/latest",
        pipeline_root=PIPELINE_ROOT_PATH,
        location=REGION,
        enable_caching=False,
        parameter_values={"name": "Coucou CF"},
    )
    job.submit(service_account=SERVICE_ACCOUNT)
    return "Job submitted"
