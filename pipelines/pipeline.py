"""Entry point to compile and run the pipeline."""
import os

import google.cloud.aiplatform as aip
import kfp
from dotenv import load_dotenv
from kfp import compiler
from kfp.registry import RegistryClient

from components.hello_world import hello_world
from config.config import ROOT_PATH

load_dotenv(dotenv_path=ROOT_PATH / "config/.env.shared")

PROJECT_ID = os.getenv("PROJECT_ID")
REGION = os.getenv("REGION")
PIPELINE_ROOT_PATH = os.getenv("PIPELINE_ROOT_PATH")
SERVICE_ACCOUNT_ID_PIPELINE = os.getenv("SERVICE_ACCOUNT_ID_PIPELINE")
service_account = f"{SERVICE_ACCOUNT_ID_PIPELINE}@{PROJECT_ID}.iam.gserviceaccount.com"


@kfp.dsl.pipeline(name="hello-world-pipeline")
def pipeline(name: str) -> None:
    """Test pipeline."""
    hello_world_op = hello_world(name=name)  # noqa: F841


if __name__ == "__main__":
    pipeline_filename = "hello_pipeline.yaml"
    compiler.Compiler().compile(
        pipeline_func=pipeline,
        package_path=pipeline_filename,
        pipeline_parameters={"name": "default"},
    )
    client = RegistryClient(host=f"https://{REGION}-kfp.pkg.dev/{PROJECT_ID}/pipelines")
    client.upload_pipeline(file_name=pipeline_filename, tags=["latest"])
    aip.init(
        project=PROJECT_ID,
        staging_bucket=PIPELINE_ROOT_PATH,
    )

    # Prepare the pipeline job
    job = aip.PipelineJob(
        display_name="hello-world-pipeline-job",
        template_path="hello_pipeline.yaml",
        pipeline_root=PIPELINE_ROOT_PATH,
        location=REGION,
        parameter_values={"name": "Coucou"},
    )

    job.run(service_account=service_account)
