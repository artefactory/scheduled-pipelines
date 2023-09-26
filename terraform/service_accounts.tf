resource "google_service_account" "service_account_scheduler" {
  account_id   = local.pipeline_config_file.project.scheduler_service_account_name
  display_name = "Used by cloud scheduler to call cloud function"
}

resource "google_cloudfunctions_function_iam_member" "call_cloud_function_from_scheduler" {
  cloud_function = google_cloudfunctions_function.cloud_function.name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:${google_service_account.service_account_scheduler.email}"
}

resource "google_service_account" "service_account_pipeline" {
  account_id   = local.pipeline_config_file.project.pipeline_service_account_name
  display_name = "Used by cloud function to run a Vertex Pipeline"
}

resource "google_project_iam_member" "pipeline_access" {
  project = local.pipeline_config_file.project.id
  role    = "roles/editor" // TODO: restrict to only the required permissions
  member  = "serviceAccount:${google_service_account.service_account_pipeline.email}"
}

resource "google_artifact_registry_repository_iam_member" "pipeline_registry_storage" {
  location   = local.pipeline_config_file.project.region
  repository = google_artifact_registry_repository.pipeline_registry.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.service_account_pipeline.email}"
}

resource "google_storage_bucket_iam_member" "pipeline_artifacts" {
  bucket = google_storage_bucket.pipeline_artifact_bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.service_account_pipeline.email}"
}
