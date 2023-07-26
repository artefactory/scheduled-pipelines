"""Cloud function to run a Vertex pipeline."""
import json
import os

import flask
import functions_framework
from google.cloud import aiplatform
from loguru import logger

PROJECT_ID = os.getenv("PROJECT_ID")
REGION = os.getenv("REGION")
PIPELINE_ROOT_PATH = os.getenv("PIPELINE_ROOT_PATH")
SERVICE_ACCOUNT_ID_PIPELINE = os.getenv("SERVICE_ACCOUNT_ID_PIPELINE")


@functions_framework.http
def run_vertex_pipeline(request: flask.request) -> str:  # noqa: ARG001
    """Run Vertex pipeline."""
    request_str = request.data.decode("utf-8")
    logger.info(f"Request0: {request_str}")
    request_json = json.loads(request_str)
    logger.info(f"Request: {request_json}")

    if request_json and "name" in request_json:
        name = request_json["name"]
    else:
        raise ValueError("JSON is invalid, or missing a 'name' property")

    aiplatform.init(
        project=PROJECT_ID,
        location=REGION,
    )

    job = aiplatform.PipelineJob(
        display_name="hello-world-cloud-function-pipeline",
        template_path="https://europe-west1-kfp.pkg.dev/ls-scheduled-pipelines-2c8b/pipelines/hello-world-pipeline/latest",
        # TODO: param
        pipeline_root=PIPELINE_ROOT_PATH,
        location=REGION,
        enable_caching=False,
        parameter_values={"name": name},
    )
    job.submit(
        service_account=f"{SERVICE_ACCOUNT_ID_PIPELINE}@{PROJECT_ID}.iam.gserviceaccount.com"
    )
    return "Job submitted"
