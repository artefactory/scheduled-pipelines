variable "config_file" {
  type = object({
    project = object({
      id     = string
      region = optional(string, "europe-west1")
    }),
    pipeline_info = object({
      pipeline_root_path           = string
      service_account_id_pipeline  = string
      service_account_id_scheduler = string
      repository_name              = string
      cloud_function_name          = string
    }),
    scheduled_pipelines = list(object({
      scheduler = object({
        name          = string
        cron_schedule = string
      }),
      pipeline = object({
        name         = string
        display_name = string
        parameter_values = list(object({
          key   = string
          value = string
        }))
      })
    }))
  })
  description = "Configuration file for the Terraform script"
  validation {
    condition     = can(regex("^(([0-5]?[0-9]|\\*)\\s+){4}([0-5]?[0-9]|\\*)$", var.config_file.scheduled_pipelines.*.scheduler.cron_schedule))
    error_message = "The cron_schedule must be a valid cron expression. For example, '*/5 * * * *'."
  }
}


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
