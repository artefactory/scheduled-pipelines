locals {
  yaml_config = yamldecode(file("../config/config.yaml"))
}

# module "schedule_pipeline" {
#   source = "./modules/schedule_pipeline"
#   for_each =
# }
