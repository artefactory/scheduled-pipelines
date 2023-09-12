resource "google_cloud_scheduler_job" "job" {
  name             = var.scheduler.name
  description      = "Schedule the pipeline"
  schedule         = var.scheduler.cron_schedule
  time_zone        = "CET"
  attempt_deadline = "320s"
  http_target {
    http_method = "POST"
    uri         = var.scheduler.cloud_function_uri
    # body        = var.pipeline.parameter_values # TODO
    oidc_token {
      service_account_email = var.scheduler.service_account_email
    }
  }
}

resource "google_cloudfunctions_function_iam_member" "call_cloud_function" {
  cloud_function = var.scheduler.cloud_function_name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:${var.scheduler.service_account_email}"
}
