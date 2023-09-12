resource "google_storage_bucket" "pipeline_artifact_bucket" {
  name          = replace(local.config_file.project.pipeline_root_path, "gs://", "")
  location      = local.config_file.project.region
  force_destroy = true
}
