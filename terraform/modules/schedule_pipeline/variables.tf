variable "pipeline" {
  type = object({
    cron_schedule         = string
    time_zone             = string
    scheduler_name        = string
    pipeline_name         = string
    pipeline_display_name = string
    enable_caching        = bool
    parameter_values = list(object({
      key   = string
      value = string
    }))
    retry_config = object({
      min_backoff_duration = optional(string, "5s")
      max_backoff_duration = optional(string, "1h")
      max_retry_duration   = optional(string, "0s")
      max_doublings        = optional(number, 5)
      retry_count          = optional(number, 0)
    })
    attempt_deadline = optional(string, "320s")
  })
}


variable "cloud_function_uri" {
  type = string
}
variable "service_account_email" {
  type = string
}
