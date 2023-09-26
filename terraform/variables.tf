locals {
  pipeline_config_file = yamldecode(file("../scheduled_pipelines_config.yaml"))
  pipeline_root_path   = "gs://${local.pipeline_config_file.project.id}-${local.pipeline_config_file.project.staging_bucket_suffix}"
}
