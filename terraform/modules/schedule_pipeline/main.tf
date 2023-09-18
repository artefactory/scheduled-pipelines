locals {
  http_body_raw = merge(
    {
      "parameter_values" = var.pipeline.parameter_values
    },
    {
      "pipeline_name"  = var.pipeline.pipeline_name,
      "display_name"   = var.pipeline.pipeline_display_name,
      "enable_caching" = var.pipeline.enable_caching
    }
  )
}

resource "google_cloud_scheduler_job" "pipeline_scheduler" {
  name        = var.pipeline.scheduler_name
  description = "Schedule the pipeline"
  schedule    = var.pipeline.cron_schedule
  time_zone   = var.pipeline.time_zone
  http_target {
    http_method = "POST"
    uri         = var.cloud_function_uri
    body        = base64encode(jsonencode(local.http_body_raw))
    oidc_token {
      service_account_email = var.service_account_email
    }
  }
  attempt_deadline = var.pipeline.attempt_deadline
  retry_config {
    min_backoff_duration = var.pipeline.retry_config.min_backoff_duration
    max_backoff_duration = var.pipeline.retry_config.max_backoff_duration
    max_retry_duration   = var.pipeline.retry_config.max_retry_duration
    max_doublings        = var.pipeline.retry_config.max_doublings
    retry_count          = var.pipeline.retry_config.retry_count
  }
}
