terraform {
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
