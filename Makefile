DB_HOST = $(shell cd terraform/env && terraform output db_host)
DB_NAME = $(shell cd terraform/env && terraform output db_name)
DB_USER = $(shell cd terraform/env && terraform output db_user)

ami: roles
	cd terraform/env && \
		packer build \
			-var db_host=$(DB_HOST) \
			-var db_name=$(DB_NAME) \
			-var db_user=$(DB_USER) \
			-var "db_pass=${TF_VAR_db_pass}" \
			../../packer/wordpress.json

validate: roles
	cd ansible && ansible-playbook --syntax-check -i "localhost," -c local wordpress.yml
	packer validate -syntax-only packer/wordpress.json
	cd terraform/bootstrap && terraform validate
	cd terraform/mgmt && terraform validate
	cd terraform/env && terraform validate

roles:
	# this command fails if the requirements.yml is empty
	# cd ansible && ansible-galaxy install -p roles -r requirements.yml
