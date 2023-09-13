variable "pipeline" {
  type = object({
    cron_schedule         = string
    time_zone             = string
    scheduler_name        = string
    pipeline_name         = string
    pipeline_display_name = string
    enable_caching        = bool
    cloud_function_uri    = string
    service_account_email = string
    parameter_values = list(object({
      key   = string
      value = string
    }))
  })
}
