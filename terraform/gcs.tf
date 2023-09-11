resource "google_storage_bucket" "pipeline_artifact_bucket" {
  name     = replace(var.pipeline_root_path, "gs://", "")
  location = var.region
}
