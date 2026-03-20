TERRAFORM_DIR=infra/terraform
ANSIBLE_DIR=config/ansible

tf-init:
	cd $(TERRAFORM_DIR) && terraform init

tf-fmt:
	cd $(TERRAFORM_DIR) && terraform fmt -recursive

tf-validate:
	cd $(TERRAFORM_DIR) && terraform validate

tf-plan:
	cd $(TERRAFORM_DIR) && terraform plan

tf-apply:
	cd $(TERRAFORM_DIR) && terraform apply

tf-destroy:
	cd $(TERRAFORM_DIR) && terraform destroy

tf-output:
	cd $(TERRAFORM_DIR) && terraform output

update-ip:
	cd $(TERRAFORM_DIR) && terraform output -raw ec2_public_ip > /tmp/ec2_ip

	echo "[aws]" > $(ANSIBLE_DIR)/inventory/hosts.ini
	echo "ec2 ansible_host=$$(cat /tmp/ec2_ip)" >> $(ANSIBLE_DIR)/inventory/hosts.ini
	echo "" >> $(ANSIBLE_DIR)/inventory/hosts.ini
	echo "[aws:vars]" >> $(ANSIBLE_DIR)/inventory/hosts.ini
	echo "ansible_user=ubuntu" >> $(ANSIBLE_DIR)/inventory/hosts.ini
	echo "ansible_ssh_private_key_file=~/.ssh/id_rsa" >> $(ANSIBLE_DIR)/inventory/hosts.ini

wait-ssh:
	@IP=$$(cat /tmp/ec2_ip); \
	echo "Waiting for SSH on $$IP..."; \
	for i in $$(seq 1 30); do \
		if nc -z $$IP 22; then \
			echo "SSH is up on $$IP"; \
			exit 0; \
		fi; \
		echo "Attempt $$i/30: SSH not ready yet..."; \
		sleep 10; \
	done; \
	echo "SSH did not become ready in time"; \
	exit 1

ansible:
	cd $(ANSIBLE_DIR) && ansible-playbook playbook.yml

ansible-ping:
	cd $(ANSIBLE_DIR) && ansible all -m ping
	
deploy-lab:
	make tf-init
	make tf-fmt
	make tf-validate
	make tf-plan
	make tf-apply

deploy-ansible:
	make update-ip
	make wait-ssh
	make ansible