variable "scheduler" {
  type = object({
    name          = string
    cron_schedule = string
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
