# help: build_resources				- Build cloud resources with terraform
.PHONY: build_resources
build_resources:
	@make build_tf_state_bucket && make zip_cloud_function && cd terraform && terraform init && terraform apply

# help: build_tf_state_bucket			- Build terraform state bucket
.PHONY: build_tf_state_bucket
build_tf_state_bucket:
	@bash bin/create_tf_state_bucket.sh

# help: deploy_docs				- Deploy documentation to GitHub Pages
.PHONY: deploy_docs
deploy_docs:
	@mkdocs build
	@mkdocs gh-deploy

# help: help					- Display this makefile's help information
.PHONY: help
help:
	@grep "^# help\:" Makefile | grep -v grep | sed 's/\# help\: //' | sed 's/\# help\://'

# help: upload_template <path_to_yaml_file>	- Upload pipeline template to Artifact Registry
.PHONY: upload_template
upload_template:
	@bash bin/upload_pipeline_template.sh $(filter-out $@,$(MAKECMDGOALS))

# help: zip_cloud_function 			- Zip cloud function source code, used for terraform deployment
.PHONY: zip_cloud_function
zip_cloud_function:
	@cd cloud_function && zip cloud_function.zip main.py requirements.txt && mv cloud_function.zip ../terraform/cloud_function.zip
