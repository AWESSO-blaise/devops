#!/bin/bash
IP=$(vagrant ssh -c "hostname -I | awk '{print \$2}'" 2>/dev/null | tr -d '\r')
echo "VM IP: $IP"
cat > inventory.ini << EOF
[k3s]
k3s-server ansible_host=$IP ansible_user=vagrant ansible_ssh_private_key_file=.vagrant/machines/default/virtualbox/private_key ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF
echo "Inventory created: inventory.ini"
