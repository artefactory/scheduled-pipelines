resource "google_artifact_registry_repository" "pipeline_registry" {
  repository_id = var.repository_name
  location      = var.region
  format        = "KFP"
  description   = "Artifact registry used to store pipeline templates"
}
