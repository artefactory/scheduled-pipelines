resource "random_string" "random_suffix_bucket" {
  length  = 4
  numeric = false
  upper   = false
  special = false

}

resource "google_storage_bucket" "cloud_function_bucket" {
  name          = "cloud_function_code_bucket_${random_string.random_suffix_bucket.result}"
  location      = local.pipeline_config_file.project.region
  force_destroy = true
}

resource "google_storage_bucket_object" "cloud_function_code" {
  bucket = google_storage_bucket.cloud_function_bucket.name
  name   = "cloud_function_source_code.zip"
  source = "./cloud_function.zip"
}

resource "google_cloudfunctions_function" "cloud_function" {
  name                  = "scheduled-vertex-pipeline-runner"
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
    PROJECT_ID                  = local.pipeline_config_file.project.id
    REGION                      = local.pipeline_config_file.project.region
    PIPELINE_ROOT_PATH          = local.pipeline_root_path
    SERVICE_ACCOUNT_ID_PIPELINE = local.pipeline_config_file.project.pipeline_service_account_name
    REPOSITORY_NAME             = local.pipeline_config_file.project.repository_name
  }
}
