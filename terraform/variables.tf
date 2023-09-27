locals {
  pipeline_config_file = yamldecode(file("../scheduled_pipelines_config.yaml"))

  staging_bucket_suffix          = contains(keys(local.pipeline_config_file.project), "staging_bucket_suffix") ? local.pipeline_config_file.project.staging_bucket_suffix : "pipeline-artifacts"
  pipeline_service_account_name  = contains(keys(local.pipeline_config_file.project), "pipeline_service_account_name") ? local.pipeline_config_file.project.pipeline_service_account_name : "vertex-pipelines"
  pipeline_service_account_roles = contains(keys(local.pipeline_config_file.project), "pipeline_service_account_roles") ? local.pipeline_config_file.project.pipeline_service_account_roles : ["roles/editor"]
  scheduler_service_account_name = contains(keys(local.pipeline_config_file.project), "scheduler_service_account_name") ? local.pipeline_config_file.project.scheduler_service_account_name : "vertex-scheduler"
  pipeline_root_path             = "gs://${local.pipeline_config_file.project.id}-${local.staging_bucket_suffix}"
}
