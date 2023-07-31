# help: help					- Display this makefile's help information
.PHONY: help
help:
	@grep "^# help\:" Makefile | grep -v grep | sed 's/\# help\: //' | sed 's/\# help\://'

# help: install					- Create a conda virtual environment and install dependencies
.PHONY: install
install:
	@bash bin/install.sh

# help: install_precommit			- Install pre-commit hooks
.PHONY: install_precommit
install_precommit:
	@pre-commit install -t pre-commit
	@pre-commit install -t pre-push

# help: deploy_docs				- Deploy documentation to GitHub Pages
.PHONY: deploy_docs
deploy_docs:
	@mkdocs build
	@mkdocs gh-deploy

# help: cloud_setup				- Setup cloud environment (service accounts, roles and resources)
.PHONY: cloud_setup
cloud_setup:
	@bash bin/cloud_setup.sh
