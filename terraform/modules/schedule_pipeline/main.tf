resource "google_cloud_scheduler_job" "job" {
  name             = var.pipeline.scheduler_name
  description      = "Schedule the pipeline"
  schedule         = var.pipeline.cron_schedule
  time_zone        = "CET"
  attempt_deadline = "320s"
  http_target {
    http_method = "POST"
    uri         = var.pipeline.cloud_function_uri
    body        = base64encode(var.pipeline.parameter_values) // TODO: add other params
    oidc_token {
      service_account_email = var.pipeline.service_account_email
    }
  }
}
