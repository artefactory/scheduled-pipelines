terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.81.0"
    }
  }
}

provider "google" {
  project = var.config_file.project.id
  region  = var.config_file.project.region
}
