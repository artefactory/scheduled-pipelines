locals {
  config_files = yamldecode(file("../config/config.yaml"))
}

output "test" {
  value = local.config_files
}
