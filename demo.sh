#!/bin/bash
echo "========================================="
echo "   DEMO DevOps - Lacets Connectes API"
echo "========================================="

echo ""
echo ">>> PARTIE 1 - Lancement de l'infrastructure..."
vagrant up

echo ""
echo ">>> Recuperation de l'IP et generation de l'inventaire Ansible..."
bash scripts/get_ip.sh
cat inventory.ini

echo ""
echo ">>> PARTIE 3 - Verification du deploiement Kubernetes..."
vagrant ssh -c "sudo kubectl get all"

echo ""
echo ">>> Test de l'API..."
POD=$(vagrant ssh -c "sudo kubectl get pods -l app=laces-api -o jsonpath='{.items[0].metadata.name}'" 2>/dev/null | tr -d '\r')
vagrant ssh -c "sudo kubectl exec -it $POD -- wget -qO- http://localhost:3000/health"

echo ""
echo "========================================="
echo "   DEMO TERMINEE AVEC SUCCES !"
echo "========================================="
