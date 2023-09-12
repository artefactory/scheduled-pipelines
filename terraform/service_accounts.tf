resource "google_service_account" "service_account_scheduler" {
  account_id   = var.config_file.pipeline_info.service_account_id_scheduler
  display_name = "Service Account used to scheduler Vertex pipeline"
}

resource "google_cloudfunctions_function_iam_member" "call_cloud_function" {
  cloud_function = google_cloudfunctions_function.cloud_function.name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:${google_service_account.service_account_scheduler.email}"
}

resource "google_service_account" "service_account_pipeline" {
  account_id   = var.config_file.pipeline_info.service_account_id_pipeline
  display_name = "Service Account used to run Vertex pipeline"
}

resource "google_project_iam_member" "pipeline_access" {
  project = var.config_file.project.id
  role    = "roles/editor" // TODO: restrict to only the required permissions
  member  = "serviceAccount:${google_service_account.service_account_pipeline.email}"
}

resource "google_artifact_registry_repository_iam_member" "pipeline_registry_storage" {
  location   = var.config_file.project.region
  repository = google_artifact_registry_repository.pipeline_registry.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.service_account_pipeline.email}"
}

resource "google_storage_bucket_iam_member" "pipeline_artifacts" {
  bucket = google_storage_bucket.pipeline_artifact_bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.service_account_pipeline.email}"
}
