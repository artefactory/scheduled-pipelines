module "schedule_pipeline" {
  source                = "./modules/schedule_pipeline"
  for_each              = local.pipeline_config_file.scheduled_pipelines
  cloud_function_uri    = google_cloudfunctions_function.cloud_function.https_trigger_url
  service_account_email = google_service_account.service_account_scheduler.email
  pipeline              = each.value
}
