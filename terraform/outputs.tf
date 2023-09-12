locals {
  config_files = yamldecode(file("../config/config.yaml"))
}

output "configuration" {
  value = local.config_files
}
