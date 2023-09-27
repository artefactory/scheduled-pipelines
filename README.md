# Vertex Pipelines Scheduler Accelerator

This repository enables to easily schedule existing Vertex pipelines.

It uploads Vertex pipelines templates to an Artifact Registry repository and schedules pipelines using Cloud Scheduler and Cloud Functions.

<img src="assets/infra.png">

It does for you the creation of the required service accounts, configures the required permissions and creates the necessary cloud resources.

## Table of Contents

- [Vertex Pipelines Scheduler Accelerator](#vertex-pipelines-scheduler-accelerator)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Sanity check](#sanity-check)
  - [Troubleshooting](#troubleshooting)
  - [More details](#more-details)

## Prerequisites

- Unix-like environment (Linux, macOS, WSL, etc... Tested on MacOS Monterey, M1 chip)
- Google SDK (gcloud) (instructions [here](https://cloud.google.com/sdk/docs/install#installation_instructions))
- Terraform (tested for version v1.5.6 on darwin_arm64) (instructions [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform))
- Having `wget` installed (instructions [here](https://www.gnu.org/software/wget/) for Linux and for MacOS: `brew install wget`)
- Having `yq` installed (instructions [here](https://github.com/mikefarah/yq/#install) for Linux and for MacOS: `brew install yq`)
- Having a compiled Vertex pipeline (instructions [here](https://cloud.google.com/vertex-ai/docs/pipelines/build-pipeline#compile_your_pipeline_into_a_yaml_file))

> Note: if you don't have a compiled pipeline or have trouble compiling it, you can use the [`hello_world_pipeline.yaml`](pipelines/hello_world_pipeline.yaml) file in the `pipelines`directory to test the scheduling.

## Setup

First, you need to setup authentication to Google Cloud (select the relevant Google account and project):

```bash
export GCP_PROJECT_ID=<gcp_project_id>
gcloud config set project $GCP_PROJECT_ID
gcloud auth login
gcloud auth application-default login
```

## Installation

If not done already, download this repository on your local machine:

```bash
wget -O scheduled-pipelines.zip https://github.com/artefactory/scheduled-pipelines/archive/main.zip
```

Then unzip it:

```bash
unzip scheduled-pipelines.zip \
&& rm scheduled-pipelines.zip \
&& mv scheduled-pipelines-main scheduled-pipelines \
&& cd scheduled-pipelines
```

## Usage

To use this repository, you need to:

1. Replace the values in your configuration file  [`scheduled_pipelines_config.yaml`](scheduled_pipelines_config.yaml) with the values **corresponding to your project**.

2. Enable the required APIs:

```bash
gcloud services enable \
  cloudscheduler.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  artifactregistry.googleapis.com \
  storage-component.googleapis.com \
  aiplatform.googleapis.com \
  --project=$GCP_PROJECT_ID
```

3. Create a directory with the compiled pipeline(s) inside & deploy the scheduled pipeline(s) and its (their) infrastructure:

```bash
make deploy_scheduled_pipeline <path_to_pipeline_templates_directory>
```

This command will:

- Create the service accounts used to run the scheduled pipelines and schedule them.
- Create the necessary cloud resources (Cloud Scheduler, Cloud Functions, Artifact Registry repository).
- Give the appropriate permissions to the service accounts.
- Upload the pipeline templates to the Artifact Registry repository.

> Note: you can use the dummy pipeline to test the scheduling:
```bash
make deploy_scheduled_pipeline pipelines
```

## Sanity check

To check that everything is working as expected, you can go to the Cloud Scheduler page in the Google Cloud console and make sure the right schedulers are present.
Then, you can trigger a force run of one of the scheduler and check that the Vertex pipeline is running as expected (go to Vertex AI > Pipelines and select the right region).

<img src="assets/cloud_schedulers.png" alt="Cloud schedulers" />

> Note: It might take a few minutes for the scheduler to work properly with the cloud function.

## Troubleshooting

1. Check that the "Status of last execution" of the scheduler is "Success". If this is not the case:

First check the logs of the cloud scheduler to see whether the error is coming from the scheduler (permission denied) or the cloud function (internal error).

If the error is a permission denied, check that the service account of the cloud scheduler has the right permissions on the cloud function. If the error is an internal error, check the cloud function logs (Go to the Cloud functions page, click on the cloud function name and go to the "LOGS" tab).

2. If the "Status of last execution" is "Success", check that the Vertex pipeline is running as expected (make sure you selected the right region). If this is not the case, check the logs of the cloud function.

## More details

The required permissions required to execute the `make deploy_scheduled_pipeline` command are:

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
