locals {
  pipeline_config_file = yamldecode(file("../config/config.yaml"))
}
