# Vertex Pipelines Scheduler Accelerator

[![Python Version](https://img.shields.io/badge/python-3.8%20%7C%203.9%20%7C%203.10-blue.svg)]()

[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
[![Imports: isort](https://img.shields.io/badge/%20imports-isort-%231674b1?style=flat&labelColor=ef8336)](https://pycqa.github.io/isort/)
[![Linting: ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/charliermarsh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)
[![security: bandit](https://img.shields.io/badge/security-bandit-yellow.svg)](https://github.com/PyCQA/bandit)
[![Pre-commit](https://img.shields.io/badge/pre--commit-enabled-informational?logo=pre-commit&logoColor=white)](https://github.com/artefactory-fr/scheduled-pipelines/blob/main/.pre-commit-config.yaml)

This repository enables to easily upload existing Vertex pipelines templates to an Artifact Registry repository and to schedule them using Cloud Scheduler and Cloud Functions.

It does for you the creation of the required service accounts, configure the required permissions and create the cloud resources.

## Table of Contents

- [Vertex Pipelines Scheduler Accelerator](#vertex-pipelines-scheduler-accelerator)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Sanity check](#sanity-check)
  - [Documentation](#documentation)

## Prerequisites

- Unix-like environment (Linux, macOS, WSL, etc...**** Tested on MacOS Monterey, M1 chip)
- Google SDK (gcloud)
- Conda
- Terraform (tested for version v1.5.6 on darwin_arm64)
- Having a working Vertex pipeline, ready to be compiled

## Setup

First, you need to setup authentication to Google Cloud (select the relevant Google account and project):

```bash
gcloud config set project <gcp_project_id>
gcloud auth login
gcloud auth application-default login
```

## Installation

No particular install step is required to use this package.

## Usage

To list the available commands, run:

```bash
make help
```

To use this repository, you need to:

1. Enable the following APIs in your project:
   - Cloud Scheduler API
   - Cloud Functions API
   - Cloud Build API
   - Artifact Registry API
   - Cloud Storage API
   - Vertex AI API

2. If not done already, compile the desired Vertex pipeline in a YAML file locally (instructions [here](https://cloud.google.com/vertex-ai/docs/pipelines/build-pipeline#compile_your_pipeline_into_a_yaml_file)).

3. Execute the following command to create the configuration file `config/config.yaml`:

```bash
make build_config
```

4. Replace the values in the created configuration file  `config/config.yaml` with the values corresponding to your project.

5. Run the following command to create the required service accounts and cloud resources:

```bash
make build_resources
```

This command will:

1. Create the service accounts used to run the scheduled pipelines and schedule them.
2. Create the necessary cloud resources (Cloud Scheduler, Cloud Functions, Artifact Registry repository).
3. Give the appropriate permissions to the service accounts.

Note: the required permissions required to execute these steps are:

| Resource creation        | Permission(s) required                                    |
| ------------------------ | --------------------------------------------------------- |
| Create service account   | iam.serviceAccounts.create                                |
| Create artifact registry | artifactregistry.repositories.create                      |
| Creation cloud function  | cloudfunctions.functions.create, cloudbuild.builds.create |
| Create cloud scheduler   | cloudscheduler.jobs.create                                |

| Resource to give permission on (iam-policy-binding) | Permission required                        |
| ----------------- | ------------------------------------------ |
| Project           | resourcemanager.projects.setIamPolicy      |
| Cloud storage     | storage.buckets.setIamPolicy               |
| Cloud function    | cloudfunctions.functions.setIamPolicy      |
| Artifact registry | artifactregistry.repositories.setIamPolicy |


6. Upload the YAML file to the Artifact Registry repository using the following command:

```bash
make upload_template <path_to_local_pipeline_yaml_file>
```

## Sanity check

To check that everything is working as expected, you can go to the Cloud Scheduler page in the Google Cloud console and make sure the right schedulers are present.
Then, you can trigger a force run of one of the scheduler and check that the pipeline is running as expected.

## Documentation

This documentation is available on [Skaff](https://artefact.roadie.so/docs/default/Component/scheduled-pipelines).
