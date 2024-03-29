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
REPOSITORY_NAME = os.getenv("REPOSITORY_NAME")


@functions_framework.http
def run_vertex_pipeline(request: flask.request) -> str:  # noqa: ARG001
    """Run Vertex pipeline."""
    request_str = request.data.decode("utf-8")
    request_json = json.loads(request_str)
    logger.info(f"Request from cloud scheduler: {request_json}")
    required_fields = ["pipeline_name", "parameter_values", "enable_caching"]

    if request_json:
        for required_field in required_fields:
            if required_field not in request_json:
                raise ValueError(f"JSON request body is invalid, or missing a '{required_field}' property")
        pipeline_name = request_json[
            "pipeline_name"
        ]  # Note: This is the name written in the pipeline decorator when defining the pipeline
        # This is the value used to identify the YAML pipeline file in the Artifact registry
        parameter_values = request_json["parameter_values"]
        enable_caching = request_json["enable_caching"]
    else:
        raise ValueError("JSON request body is invalid/missing")

    aiplatform.init(
        project=PROJECT_ID,
        location=REGION,
    )

    job = aiplatform.PipelineJob(
        display_name=pipeline_name,
        template_path=f"https://{REGION}-kfp.pkg.dev/{PROJECT_ID}/{REPOSITORY_NAME}/{pipeline_name}/latest",
        pipeline_root=f"{PIPELINE_ROOT_PATH}/{pipeline_name}",
        location=REGION,
        enable_caching=enable_caching,
        parameter_values=parameter_values,
    )
    job.submit(
        service_account=f"{SERVICE_ACCOUNT_ID_PIPELINE}@{PROJECT_ID}.iam.gserviceaccount.com"
    )
    return "Job submitted"
