variable "pipeline" {
  type = object({
    pipeline_name    = string
    cron_schedule    = string
    time_zone        = string
    enable_caching   = bool
    parameter_values = map(string)
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
