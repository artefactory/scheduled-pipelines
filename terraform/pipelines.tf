module "schedule_pipeline" {
  source   = "./modules/schedule_pipeline"
  for_each = local.config_file.scheduled_pipelines
  pipeline = {
    "cron_schedule" : each.value["cron_schedule"],
    "scheduler_name" : each.value["scheduler_name"],
    "pipeline_name" : each.value["pipeline_name"],
    "pipeline_display_name" : each.value["pipeline_display_name"],
    "cloud_function_uri" = google_cloudfunctions_function.cloud_function.https_trigger_url,
    "service_account_email" : google_service_account.service_account_scheduler.email,
    "parameter_values" : each.value["parameter_values"]
  }
}
