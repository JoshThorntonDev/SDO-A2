#!/bin/bash
set +ex

## Hacky way to build inventory file
echo "all:" > ansible/inventory.yml
echo "  hosts:" >> ansible/inventory.yml

echo "    "$(cd infra && terraform output -raw public_ip) >> ansible/inventory.yml

USERNAME=$(cd infra && terraform output -raw db_username)
PASSWORD=$(cd infra && terraform output -raw db_pw)
DNS_NAME=$(cd infra && terraform output -raw db_dns_name)


echo "  vars:" >> ansible/inventory.yml
echo "    db_url: mongodb://$USERNAME:$PASSWORD@$DNS_NAME" >> ansible/inventory.yml