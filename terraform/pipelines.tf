module "schedule_pipeline" {
  source   = "./modules/schedule_pipeline"
  for_each = var.config_file.scheduled_pipelines
  scheduler = merge(
    each.value.scheduler,
    {
      "cloud_function_uri" = google_cloudfunctions_function.cloud_function.https_trigger_url,
      "service_account_email" : google_service_account.service_account_scheduler.email,
      "cloud_function_name" : google_cloudfunctions_function.cloud_function.name
  })
  pipeline = each.value.pipeline
}
