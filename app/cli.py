"""Entry point to compile and run the pipeline."""

import os

import typer
from dotenv import load_dotenv
from kfp.registry import RegistryClient

from config.config import ROOT_PATH

load_dotenv(dotenv_path=ROOT_PATH / "secrets/.env")

PROJECT_ID = os.getenv("PROJECT_ID")
REGION = os.getenv("REGION")
REPOSITORY_NAME = os.getenv("REPOSITORY_NAME")

app = typer.Typer()


@app.command()
def upload_compiled_pipeline(path_to_pipeline_template: str) -> None:
    """Upload the compiled pipeline (YAML file) to Artifact registry."""
    client = RegistryClient(host=f"https://{REGION}-kfp.pkg.dev/{PROJECT_ID}/{REPOSITORY_NAME}")
    client.upload_pipeline(
        file_name=path_to_pipeline_template, tags=["latest"]
    )  # This function requires a str filename


if __name__ == "__main__":
    app()
