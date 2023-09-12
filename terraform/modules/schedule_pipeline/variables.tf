variable "scheduler" {
  type = object({
    name                  = string
    cron_schedule         = string
    cloud_function_uri    = string
    service_account_email = string
    cloud_function_name   = string
  })
}
variable "pipeline" {
  type = object({
    name         = string
    display_name = string
    parameter_values = list(object({
      key   = string
      value = string
    }))
  })
}
