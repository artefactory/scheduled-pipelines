"""Hello World component""" ""
from kfp.v2.dsl import component


@component(base_image="python:3.9", packages_to_install=["loguru"])
def hello_world(name: str) -> str:
    """Print Hello World!"""
    from loguru import logger

    logger.info(f"Hello {name}!")
    return "Hello World!"
