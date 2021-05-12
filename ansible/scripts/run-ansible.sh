#!/bin/bash
set +ex

## Hacky way to build inventory file
echo "all:" > ansible/inventory.yml
echo "  hosts:" >> ansible/inventory.yml

echo "    "$(cd infra && terraform output -raw public_ip) >> ansible/inventory.yml



echo "  vars:" >> ansible/inventory.yml
echo "    db_url: mongodb://"$(cd infra && terraform output -raw db_username)":"$(cd infra && terraform output -raw db_pw)"@"$(cd infra && terraform output -raw db_dns_name) >> ansible/inventory.yml