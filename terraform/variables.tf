locals {
  config_file = yamldecode(file("../config/config.yaml"))
}

# variable "config_file" {
#   type = object({
#     project = object({
#       id     = string
#       region = optional(string, "europe-west1")
#     }),
#     pipeline_info = object({
#       pipeline_root_path           = string
#       service_account_id_pipeline  = string
#       service_account_id_scheduler = string
#       repository_name              = string
#       cloud_function_name          = string
#     }),
#     scheduled_pipelines = list(object({
#       scheduler = object({
#         name          = string
#         cron_schedule = string
#       }),
#       pipeline = object({
#         name         = string
#         display_name = string
#         parameter_values = list(object({
#           key   = string
#           value = string
#         }))
#       })
#     }))
#   })
#   # default     = local.config_files
#   description = "Configuration file for the Terraform script"
#   validation {
#     condition     = can(regex("^(([0-5]?[0-9]|\\*)\\s+){4}([0-5]?[0-9]|\\*)$", local.config_file.scheduled_pipelines.*.scheduler.cron_schedule))
#     error_message = "The cron_schedule must be a valid cron expression. For example, '*/5 * * * *'."
#   }
# }
