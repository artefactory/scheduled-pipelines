resource "google_artifact_registry_repository" "pipeline_registry" {
  repository_id = var.config_file.pipeline_info.repository_name
  location      = var.config_file.project.region
  format        = "KFP"
  description   = "Artifact registry used to store pipeline templates"
}
