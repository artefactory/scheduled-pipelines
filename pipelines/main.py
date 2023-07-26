"""Entry point to compile and run the pipeline."""

import ast
import os

import google.cloud.aiplatform as aip
import typer
from dotenv import load_dotenv
from kfp import compiler
from kfp.registry import RegistryClient

from config.config import ROOT_PATH
from pipelines.pipeline import pipeline

load_dotenv(dotenv_path=ROOT_PATH / "config/.env.shared")

PROJECT_ID = os.getenv("PROJECT_ID")
REGION = os.getenv("REGION")
PIPELINE_ROOT_PATH = os.getenv("PIPELINE_ROOT_PATH")
SERVICE_ACCOUNT_ID_PIPELINE = os.getenv("SERVICE_ACCOUNT_ID_PIPELINE")
REPOSITORY_NAME = os.getenv("REPOSITORY_NAME")
SIMPLE_PIPELINE_NAME = os.getenv("SIMPLE_PIPELINE_NAME")
service_account = f"{SERVICE_ACCOUNT_ID_PIPELINE}@{PROJECT_ID}.iam.gserviceaccount.com"


def compile_pipeline(upload_to_ar: bool = True) -> None:
    """Compile the pipeline and upload it to Artifact registry, if wanted."""
    pipeline_filename = str(
        ROOT_PATH / "local_registry/hello_pipeline.yaml"
    )  # The compiler requires a str path
    compiler.Compiler().compile(
        pipeline_func=pipeline,
        package_path=pipeline_filename,
        pipeline_parameters={"name": "default"},
    )
    if upload_to_ar:
        client = RegistryClient(host=f"https://{REGION}-kfp.pkg.dev/{PROJECT_ID}/{REPOSITORY_NAME}")
        client.upload_pipeline(file_name=pipeline_filename, tags=["latest"])


def run_pipeline(
    pipeline_template_path: str,
    recompile: bool = True,
    parameters: str = typer.Argument(..., callback=ast.literal_eval),
) -> None:
    """Run the pipeline.

    Args:
        pipeline_template_path (str): Either the path to the pipeline template in Artifact Registry
        or the local path.
        recompile (bool): Whether to recompile the pipeline or not.
        parameters (str): The parameters to pass to the pipeline. A stringified dict,
                          e.g. '{"key": "value"}'
    """
    if recompile:
        compile_pipeline()

    aip.init(
        project=PROJECT_ID,
        staging_bucket=PIPELINE_ROOT_PATH,
    )

    # Prepare the pipeline job
    job = aip.PipelineJob(
        display_name="hello-world-pipeline-job",
        template_path=pipeline_template_path,
        pipeline_root=PIPELINE_ROOT_PATH,
        location=REGION,
        parameter_values=parameters,
    )

    job.run(service_account=service_account)


if __name__ == "__main__":
    typer.run(run_pipeline)
