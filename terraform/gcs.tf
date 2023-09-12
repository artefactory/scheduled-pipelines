resource "google_storage_bucket" "pipeline_artifact_bucket" {
  name     = replace(var.config_file.pipeline_info.pipeline_root_path, "gs://", "")
  location = var.config_file.project.region
}
