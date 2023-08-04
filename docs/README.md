# User Guide

This repository enables to easily upload existing Vertex pipelines templates to an Artifact Registry repository and to schedule them using Cloud Scheduler and Cloud Functions.

It does for you the creation of the required service accounts, configure the required permissions and create the cloud resources.

## Table of Contents

- [User Guide](#user-guide)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
  - [Installation](#installation)
  - [Usage](#usage)

## Prerequisites

- Unix-like environment (Linux, macOS, WSL, etc... Tested on MacOS Monterey, M1 chip)
- Python 3.8+
- Conda
- Google Cloud SDK (tested for version 440.0.0)

## Setup

First, you need to setup authentication to Google Cloud (select the relevant Google account and project):

```bash
gcloud config set project <gcp_project_id>
gcloud auth login
gcloud auth application-default login
```

## Installation

To install the package in a virtual environment, run the following command:

```bash
make install
```

## Usage

To use this repository, you need to:

1. Enable the following APIs in your project:
   - Cloud Scheduler API
   - Cloud Functions API
   - Cloud Build API
   - Artifact Registry API
   - Cloud Storage API

2. Compile the desired Vertex pipeline in a YAML file (instructions [here](https://cloud.google.com/vertex-ai/docs/pipelines/build-pipeline#compile_your_pipeline_into_a_yaml_file)).

3. Upload the YAML file to the Artifact Registry repository using the following command (you have to perform installation step first and activate the conda virtual environment):

```bash
upload_template <path_to_pipeline_yaml_file>
```

5. Create the file `secrets/.env` with the appropriate values for your project. You can use the file `secrets/.env.template` as a template.

6. Replace the values in the file `config/cloud_function_params.json`. These values will be used to define the pipeline parameters and the pipeline to be scheduled (`pipeline_name`).

7. Run the following command to create the required service accounts and cloud resources:

```bash
make cloud_setup
```

This command will:

1. Create the service accounts required to run the scheduled pipelines and schedule them.
2. Create the necessary cloud resources (Cloud Scheduler, Cloud Functions, Storage Bucket, Artifact Registry repository).
3. Give the appropriate permissions to the service accounts.

Note: the required permissions required to execute these steps are:

| Resource creation        | Permission(s) required                                    |
| ------------------------ | --------------------------------------------------------- |
| Create service account   | iam.serviceAccounts.create                                |
| Create bucket            | storage.buckets.create                                    |
| Create artifact registry | artifactregistry.repositories.create                      |
| Creation cloud function  | cloudfunctions.functions.create, cloudbuild.builds.create |
| Create cloud scheduler   | cloudscheduler.jobs.create                                |

| Resource to give permission to (iam-policy-binding) | Permission required                        |
| ----------------- | ------------------------------------------ |
| Project           | resourcemanager.projects.setIamPolicy      |
| Cloud storage     | storage.buckets.setIamPolicy               |
| Cloud function    | cloudfunctions.functions.setIamPolicy      |
| Artifact registry | artifactregistry.repositories.setIamPolicy |
