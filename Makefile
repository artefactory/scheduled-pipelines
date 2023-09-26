# help: deploy_docs					- Deploy documentation to GitHub Pages
.PHONY: deploy_docs
deploy_docs:
	@mkdocs build
	@mkdocs gh-deploy

# help: deploy_scheduled_pipeline <path_to_yaml_file>	- Build cloud resources & upload pipeline template to artifact registry to have a scheduled pipeline deployed
.PHONY: deploy_scheduled_pipeline
deploy_scheduled_pipeline: zip_cloud_function
	@bash bin/create_tf_state_bucket.sh
	@cd terraform && terraform init && terraform apply -auto-approve
	@bash bin/upload_pipeline_template.sh $(filter-out $@,$(MAKECMDGOALS))

# help: help						- Display this makefile's help information
.PHONY: help
help:
	@grep "^# help\:" Makefile | grep -v grep | sed 's/\# help\: //' | sed 's/\# help\://'

# help: zip_cloud_function 				- Zip cloud function source code, used for terraform deployment
.PHONY: zip_cloud_function
zip_cloud_function:
	@cd cloud_function && zip cloud_function.zip main.py requirements.txt && mv cloud_function.zip ../terraform/cloud_function.zip
