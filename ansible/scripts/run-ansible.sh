#!/bin/bash
set +ex

## Hacky way to build inventory file
echo "all:" > inventory.yml
echo "  hosts:" >> inventory.yml

echo "   " $(cd ../infra && terraform output -raw public_ip) >> ./inventory.yml

