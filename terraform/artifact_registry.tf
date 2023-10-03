resource "google_artifact_registry_repository" "pipeline_registry" {
  repository_id = local.repository_name
  location      = local.pipeline_config_file.project.region
  format        = "KFP"
  description   = "Artifact registry used to store pipeline templates"
}
