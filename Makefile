.PHONY: up down tf-validate bootstrap ssh-gen tf-init pack
up:
	cd infra && terraform apply --auto-approve
	ansible/scripts/run-ansible.sh
	cd ansible && ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i inventory.yml --private-key ~/keys/ec2-key -u ec2-user playbook.yml
	cd infra && terraform output public_dns
down:
	cd infra && terraform destroy --auto-approve

tf-plan:
	cd infra && terraform plan

tf-validate:
	cd infra && terraform validate
	cd infra && terraform fmt

bootstrap:
	cd bootstrap && terraform init
	cd bootstrap && terraform apply --auto-approve

ssh-gen:
	mkdir -p ~/keys
	yes | ssh-keygen -t rsa -b 4096 -f ~/keys/ec2-key -P ''
	chmod 0644 ~/keys/ec2-key.pub
	chmod 0600 ~/keys/ec2-key

tf-init:
	cd infra && terraform init \
	-backend-config="bucket=$(shell cd bootstrap && terraform output -raw state_bucket_name)" \
	-backend-config="dynamodb_table=$(shell cd bootstrap && terraform output -raw dynamoDb_lock_table_name)"

pack:
	cd src && npm pack
	if [ -d "ansible/files/" ];	\
	then mv src/simpletodoapp-1.0.1.tgz ansible/files/simpletodoapp-1.0.1.tgz;\
	else \
	mkdir ansible/files/ && \
	mv src/simpletodoapp-1.0.1.tgz ansible/files/simpletodoapp-1.0.1.tgz; \
	fi
