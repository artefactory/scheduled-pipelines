<div align="center">

# scheduled-pipelines

[![CI status](https://github.com/artefactory-fr/scheduled-pipelines/actions/workflows/ci.yaml/badge.svg)](https://github.com/artefactory-fr/scheduled-pipelines/actions/workflows/ci.yaml?query=branch%3Amain)
[![Python Version](https://img.shields.io/badge/python-3.8%20%7C%203.9%20%7C%203.10-blue.svg)]()

[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)
[![Imports: isort](https://img.shields.io/badge/%20imports-isort-%231674b1?style=flat&labelColor=ef8336)](https://pycqa.github.io/isort/)
[![Linting: ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/charliermarsh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)
[![security: bandit](https://img.shields.io/badge/security-bandit-yellow.svg)](https://github.com/PyCQA/bandit)
[![Pre-commit](https://img.shields.io/badge/pre--commit-enabled-informational?logo=pre-commit&logoColor=white)](https://github.com/artefactory-fr/scheduled-pipelines/blob/main/.pre-commit-config.yaml)
</div>

This repository enables to easily schedule existing Vertex pipelines using Cloud Scheduler and Cloud Functions.
It also facilitates the creation of the required service accounts and the configuration of the required permissions.

## Table of Contents

- [scheduled-pipelines](#scheduled-pipelines)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Documentation](#documentation)
  - [Repository Structure](#repository-structure)

## Installation

To install the required packages in a virtual environment, run the following command:

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
   - Vertex AI API

2. Compile the desired Vertex pipeline (and upload it to Artifact Registry) using the command:

TODO

3. Run the following command to create the required service accounts and cloud resources:

```
make cloud_setup
```

## Documentation

TODO: Github pages is not enabled by default, you need to enable it in the repository settings: Settings > Pages > Source: "Deploy from a branch" / Branch: "gh-pages" / Folder: "/(root)"

A detailed documentation of this project is available [here](https://artefactory-fr.github.io/scheduled-pipelines/)

To serve the documentation locally, run the following command:

```bash
mkdocs serve
```

To build it and deploy it to GitHub pages, run the following command:

```bash
make deploy_docs
```

## Repository Structure

```
.
├── .github    <- GitHub Actions workflows and PR template
├── bin        <- Bash files
├── config     <- Configuration files
├── docs       <- Documentation files (mkdocs)
├── lib        <- Python modules
├── notebooks  <- Jupyter notebooks
├── secrets    <- Secret files (ignored by git)
└── tests      <- Unit tests
```
