locals {
  config_files = "nice" #yamldecode(file("../config/configd.yaml"))
}

output "test" {
  value = "yes"
}
