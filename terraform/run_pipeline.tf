resource "google_service_account" "service_account_pipeline" {
  account_id   = var.service_account_id_pipeline
  display_name = "Service Account used to run Vertex pipeline"
}

resource "google_artifact_registry_repository" "pipeline_registry" {
  repository_id = var.repository_name
  location      = var.region
  format        = "KFP"
  description   = "Artifact registry used to store pipeline templates"
}

resource "google_storage_bucket" "pipeline_artifact_bucket" {
  name     = replace(var.pipeline_root_path, "gs://", "")
  location = var.region
}

// Cloud function
resource "google_storage_bucket" "cloud_function_bucket" {
  name     = "cloud_function_code_bucket"
  location = var.region
}

resource "google_storage_bucket_object" "cloud_function_code" {
  bucket = google_storage_bucket.cloud_function_bucket.name
  name   = "cloud_function_source_code.zip"
  source = "./cloud_function.zip"
}

resource "google_cloudfunctions_function" "cloud_function" {
  name                  = "function-test"
  description           = "Cloud function to trigger the pipeline"
  runtime               = "python311"
  trigger_http          = true
  entry_point           = "run_vertex_pipeline"
  available_memory_mb   = 256
  service_account_email = google_service_account.service_account_pipeline.email
  source_archive_bucket = google_storage_bucket.cloud_function_bucket.name
  source_archive_object = google_storage_bucket_object.cloud_function_code.name
  lifecycle {
    replace_triggered_by = [google_storage_bucket_object.cloud_function_code]
  }
  environment_variables = {
    PROJECT_ID                  = var.project_id
    REGION                      = var.region
    PIPELINE_ROOT_PATH          = var.pipeline_root_path
    SERVICE_ACCOUNT_ID_PIPELINE = var.service_account_id_pipeline
    REPOSITORY_NAME             = var.repository_name
  }
}

// Giving the right access to the service account
resource "google_project_iam_member" "pipeline_access" {
  project = var.project_id
  role    = "roles/editor" // TODO: restrict to only the required permissions
  member  = "serviceAccount:${google_service_account.service_account_pipeline.email}"
}

resource "google_artifact_registry_repository_iam_member" "pipeline_registry_storage" {
  location   = var.region
  repository = google_artifact_registry_repository.pipeline_registry.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.service_account_pipeline.email}"
}

resource "google_storage_bucket_iam_member" "pipeline_artifacts" {
  bucket = google_storage_bucket.pipeline_artifact_bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.service_account_pipeline.email}"
}
