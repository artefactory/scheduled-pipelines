# help: help					- Display this makefile's help information
.PHONY: help
help:
	@grep "^# help\:" Makefile | grep -v grep | sed 's/\# help\: //' | sed 's/\# help\://'

# help: build_resources				- Build cloud resources with terraform
.PHONY: build_resources
build_resources:
	@make zip_cloud_function && source bin/set_terraform_variables.sh && cd terraform && terraform init && terraform apply -auto-approve

# help: deploy_docs				- Deploy documentation to GitHub Pages
.PHONY: deploy_docs
deploy_docs:
	@mkdocs build
	@mkdocs gh-deploy

# help: cloud_setup				- Setup cloud environment (service accounts, roles and resources)
.PHONY: cloud_setup
cloud_setup:
	@bash bin/cloud_setup.sh


# help: zip_cloud_function 			- Zip cloud function source code, used for terraform deployment
.PHONY: zip_cloud_function
zip_cloud_function:
	@cd cloud_function && zip cloud_function.zip main.py requirements.txt && mv cloud_function.zip ../terraform/cloud_function.zip

# help: upload_template <path_to_yaml_file>	- Upload pipeline template to Artifact Registry
.PHONY: upload_template
upload_template:
	@bash bin/upload_pipeline_template.sh $(filter-out $@,$(MAKECMDGOALS))
