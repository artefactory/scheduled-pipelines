variable "pipeline" {
  type = object({
    cron_schedule         = string
    scheduler_name        = string
    pipeline_name         = string
    pipeline_display_name = string
    cloud_function_uri    = string
    service_account_email = string
    parameter_values      = string
  })
}
