validate: roles
	cd ansible && ansible-playbook --syntax-check -i "localhost," -c local wordpress.yml
	packer validate -syntax-only packer/wordpress.json
	cd terraform/bootstrap && terraform validate
	cd terraform/mgmt && terraform validate
	cd terraform/env && terraform validate

roles:
	# this command fails if the requirements.yml is empty
	# cd ansible && ansible-galaxy install -p roles -r requirements.yml
