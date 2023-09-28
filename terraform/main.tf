locals {
  pipeline_config_file_raw = yamldecode(file("../scheduled_pipelines_config.yaml"))
  pipeline_config_file     = merge(local.pipeline_config_file_raw, { "scheduled_pipelines" = { for k, v in local.pipeline_config_file_raw.scheduled_pipelines : k => merge(v, { "pipeline_name" = yamldecode(file("${path.root}/../pipelines/${k}.yaml")).pipelineInfo.name }) } })

  staging_bucket_suffix          = contains(keys(local.pipeline_config_file.project), "staging_bucket_suffix") ? local.pipeline_config_file.project.staging_bucket_suffix : "pipeline-artifacts"
  pipeline_service_account_name  = contains(keys(local.pipeline_config_file.project), "pipeline_service_account_name") ? local.pipeline_config_file.project.pipeline_service_account_name : "vertex-pipelines"
  pipeline_service_account_roles = contains(keys(local.pipeline_config_file.project), "pipeline_service_account_roles") ? local.pipeline_config_file.project.pipeline_service_account_roles : ["roles/editor"]
  scheduler_service_account_name = contains(keys(local.pipeline_config_file.project), "scheduler_service_account_name") ? local.pipeline_config_file.project.scheduler_service_account_name : "vertex-scheduler"
  pipeline_root_path             = "gs://${local.pipeline_config_file.project.id}-${local.staging_bucket_suffix}"
}

module "schedule_pipeline" {
  source   = "./modules/schedule_pipeline"
  for_each = local.pipeline_config_file.scheduled_pipelines

  cloud_function_uri    = google_cloudfunctions_function.cloud_function.https_trigger_url
  service_account_email = google_service_account.service_account_scheduler.email
  pipeline              = each.value
}
