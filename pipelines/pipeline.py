"""Definition of the Vertex pipeline."""

import os

import kfp
from dotenv import load_dotenv

from components.hello_world import hello_world
from config.config import ROOT_PATH

load_dotenv(dotenv_path=ROOT_PATH / "config/.env.shared")

PROJECT_ID = os.getenv("PROJECT_ID")
REGION = os.getenv("REGION")
PIPELINE_ROOT_PATH = os.getenv("PIPELINE_ROOT_PATH")
SERVICE_ACCOUNT_ID_PIPELINE = os.getenv("SERVICE_ACCOUNT_ID_PIPELINE")
REPOSITORY_NAME = os.getenv("REPOSITORY_NAME")
SIMPLE_PIPELINE_NAME = os.getenv("SIMPLE_PIPELINE_NAME")
service_account = f"{SERVICE_ACCOUNT_ID_PIPELINE}@{PROJECT_ID}.iam.gserviceaccount.com"


@kfp.dsl.pipeline(name=SIMPLE_PIPELINE_NAME)
def pipeline(name: str) -> None:
    """Test pipeline."""
    hello_world_op = hello_world(name=name)  # noqa: F841
