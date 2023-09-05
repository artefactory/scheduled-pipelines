resource "google_service_account" "service_account_scheduler" {
    project = var.project_id
    account_id   = var.service_account_id_scheduler
    display_name = "Service Account used to scheduler Vertex pipeline"
}

resource "google_cloud_scheduler_job" "job" {
    project          = var.project_id
    region           = var.region
    name             = "schedule_pipeline"
    description      = "Schedule the pipeline"
    schedule         = var.cron_schedule
    time_zone        = "CET"
    attempt_deadline = "320s"
    http_target {
        http_method = "POST"
        uri         = google_cloudfunctions_function.cloud_function.https_trigger_url
        body        = base64encode("{\"foo\":\"bar\"}") // TODO: use JSON file
        oidc_token {
            service_account_email = google_service_account.service_account_scheduler.email
        }
    }
}

resource "google_cloudfunctions_function_iam_member" "call_cloud_function" {
    project          = var.project_id
    region           = var.region
    cloud_function = google_cloudfunctions_function.cloud_function.name
    role = "roles/cloudfunctions.invoker"
    member = "serviceAccount:${google_service_account.service_account_scheduler.email}"
}

//https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions_function.html#example-usage---public-function
//https://stackoverflow.com/a/74944901/13891969
