variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
  default     = "europe-west1"
}

variable "pipeline_root_path" {
  type        = string
  description = "GCS path to store pipeline artifacts"
}

variable "service_account_id_pipeline" {
  type        = string
  description = "Service account ID to run Vertex pipelines"
}


variable "service_account_id_scheduler" {
  type        = string
  description = "Service account ID to schedule Vertex pipelines"
}

variable "repository_name" {
  type        = string
  description = "Name of the Artifact Registry repository"
}

variable "cloud_function_name" {
  type        = string
  description = "Name of the Cloud Function running the pipeline"
}

variable "cron_schedule" {
  type        = string
  description = "Cron schedule for the Cloud Scheduler"
  default     = "0 0 * * *"
}
