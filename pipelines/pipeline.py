"""Entry point to compile and run the pipeline."""
# import google.cloud.aiplatform as aip
import kfp
from kfp import compiler
from kfp.registry import RegistryClient

from components.hello_world import hello_world

PROJECT_ID = "ls-scheduled-pipelines-2c8b"
PROJECT_REGION = "europe-west9"
PIPELINE_ROOT_PATH = "gs://pipeline_root_ls"
SERVICE_ACCOUNT = "pipeline-runner@ls-scheduled-pipelines-2c8b.iam.gserviceaccount.com"
LOCATION = "europe-west9"


@kfp.dsl.pipeline(name="hello-world-pipeline")
def pipeline(name: str) -> None:
    """Test pipeline."""
    hello_world_op = hello_world(name=name)  # noqa: F841


if __name__ == "__main__":
    pipeline_filename = "hello_pipeline.yaml"
    compiler.Compiler().compile(
        pipeline_func=pipeline,
        package_path=pipeline_filename,
        pipeline_parameters={"name": "Coucou"},
    )
    client = RegistryClient(host=f"https://{LOCATION}-kfp.pkg.dev/{PROJECT_ID}/pipelines")
    client.upload_pipeline(file_name=pipeline_filename, tags=["latest"])
    # aip.init(
    #     project=PROJECT_ID,
    #     staging_bucket=PIPELINE_ROOT_PATH,
    # )

    # # Prepare the pipeline job
    # job = aip.PipelineJob(
    #     display_name="hello-world-pipeline-job",
    #     template_path="hello_pipeline.yaml",
    #     pipeline_root=PIPELINE_ROOT_PATH,
    #     location=LOCATION,
    #     parameter_values={"name": "Coucou"},
    # )

    # job.run(service_account=SERVICE_ACCOUNT)
