.PHONY: deploy_scheduled_pipelines
deploy_scheduled_pipelines: zip_cloud_function
	@bash bin/create_tf_state_bucket.sh
	@cd terraform && terraform init && terraform apply -auto-approve
	@bash bin/upload_pipeline_template.sh
	@bash bin/logs_end_of_command.sh

# help: help						- Display this makefile's help information
.PHONY: help
help:
	@grep "^# help\:" Makefile | grep -v grep | sed 's/\# help\: //' | sed 's/\# help\://'

# help: zip_cloud_function 				- Zip cloud function source code, used for terraform deployment
.PHONY: zip_cloud_function
zip_cloud_function:
	@cd cloud_function && zip cloud_function.zip main.py requirements.txt && mv cloud_function.zip ../terraform/cloud_function.zip
