resource "google_storage_bucket" "pipeline_artifact_bucket" {
  name          = replace(local.pipeline_root_path, "gs://", "")
  location      = local.pipeline_config_file.project.region
  force_destroy = true
}
