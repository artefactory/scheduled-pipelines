terraform {
  backend "gcs" {
    bucket = "{PLACEHOLDER_FOR_SED}-tf-state"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.81.0"
    }
  }
}

provider "google" {
  project = local.config_file.project.id
  region  = local.config_file.project.region
}
