locals {
  pipeline_config_file = yamldecode(file("../config/scheduled_pipelines_config"))
}
