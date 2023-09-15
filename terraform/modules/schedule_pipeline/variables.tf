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
    retry_config = optional(object({
      min_backoff_duration = string
      max_backoff_duration = string
      max_retry_duration   = string
      max_doublings        = number
      retry_count          = number
      }), {
      min_backoff_duration = "5s"
      max_backoff_duration = "3600s"
      max_retry_duration   = "0s"
      max_doublings        = 5
      retry_count          = 0
      }
    )
    attempt_deadline = optional(string, "320s")
  })
}


variable "cloud_function_uri" {
  type = string
}
variable "service_account_email" {
  type = string
}
