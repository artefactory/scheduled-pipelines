locals {
  http_body_raw = merge(
    {
      "parameter_values" = {
        for param in var.pipeline.parameter_values : param.key => param.value
      }
    },
    {
      "pipeline_name"  = var.pipeline.pipeline_name,
      "display_name"   = var.pipeline.pipeline_display_name,
      "enable_caching" = var.pipeline.enable_caching
    }
  )
}

resource "google_cloud_scheduler_job" "pipeline_scheduler" {
  name             = var.pipeline.scheduler_name
  description      = "Schedule the pipeline"
  schedule         = var.pipeline.cron_schedule
  time_zone        = var.pipeline.time_zone
  attempt_deadline = "320s"
  http_target {
    http_method = "POST"
    uri         = var.pipeline.cloud_function_uri
    body        = base64encode(jsonencode(local.http_body_raw))
    oidc_token {
      service_account_email = var.pipeline.service_account_email
    }
  }
}
