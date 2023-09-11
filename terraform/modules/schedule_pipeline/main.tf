resource "google_cloud_scheduler_job" "job" {
  name             = var.scheduler.name
  description      = "Schedule the pipeline"
  schedule         = var.scheduler.cron_schedule
  time_zone        = "CET"
  attempt_deadline = "320s"
  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.cloud_function.https_trigger_url
    body        = var.pipeline.parameter_values
    oidc_token {
      service_account_email = google_service_account.service_account_scheduler.email
    }
  }
}

resource "google_cloudfunctions_function_iam_member" "call_cloud_function" {
  cloud_function = google_cloudfunctions_function.cloud_function.name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:${google_service_account.service_account_scheduler.email}"
}
