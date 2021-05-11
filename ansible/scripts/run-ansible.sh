#!/bin/bash
set +ex

## Hacky way to build inventory file
echo "all:" > ansible/inventory.yml
echo "  hosts:" >> ansible/inventory.yml

echo "   " $(cd infra && terraform output -raw public_ip) >> ansible/inventory.yml

