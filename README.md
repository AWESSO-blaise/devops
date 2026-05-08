# DevOps TP Final - Lacets Connectés API

---
Memebres du groupe : Awesso , Sawadogo , Coulibaly 
## ÉTAPE 1 — Lancer l'infrastructure

"Je lance une seule commande pour créer automatiquement une VM Debian sur VirtualBox avec k3s installé dessus. Tout est automatisé grâce à Vagrant."

```bash
cd ~/devops
vagrant up
```

"Vagrant télécharge et configure la VM Debian avec 2Go de RAM, installe k3s et le runner GitHub Actions automatiquement."

---

## ÉTAPE 2 — Récupérer l'IP et l'inventaire Ansible

"Ce script bash récupère automatiquement l'IP de la VM et génère un inventaire Ansible."

```bash
bash scripts/get_ip.sh
cat inventory.ini
```

---

## ÉTAPE 3 — Image Docker

"J'ai conteneurisé l'API avec un Dockerfile multi-stage optimisé. L'image fait seulement 44MB grâce à Alpine."

Ouvrir : https://hub.docker.com/r/awesso/laces-api/tags

"On voit l'image avec le tag latest, 44MB, buildée automatiquement par la pipeline CI/CD."

---

## ÉTAPE 4 — Déploiement Kubernetes

"L'API et MySQL sont déployés sur k3s. MySQL a un volume persistant. L'API est accessible uniquement depuis l'intérieur du cluster. L'autoscaler gère entre 1 et 3 pods selon la charge."

```bash
cd ~/devops
vagrant ssh k3s -c "sudo kubectl get all"
```

"On voit les pods en Running, les services en ClusterIP, et le HPA qui surveille la charge."

---

## ÉTAPE 5 — Pipeline CI/CD

"Je pousse du code sur main pour déclencher la pipeline automatiquement."

```bash
exit
cd ~/devops
echo "# update" >> README.md
git add .
git commit -m "demo: trigger pipeline"
git push origin main
```

Ouvrir : https://github.com/AWESSO-blaise/devops/actions

"Le premier job build l'image Docker et la pousse sur Docker Hub. Le deuxième job deploy tourne sur le runner self-hosted installé sur la VM et déploie sur k3s."

---

## ÉTAPE 6 — Tester l'API

"Je teste l'API directement depuis l'intérieur du cluster."

```bash
cd ~/devops
vagrant ssh k3s -c "sudo kubectl get pods"
vagrant ssh k3s -c "sudo kubectl exec -it \$(sudo kubectl get pods -l app=laces-api -o jsonpath='{.items[0].metadata.name}') -- wget -qO- http://localhost:3000/health"

```

"L'API répond avec status ok."

---
## ÉTAPE 7 — Monitoring Grafana + Prometheus

"J'ai mis en place une deuxième VM de monitoring avec Grafana et Prometheus. Node Exporter est installé sur les 2 VMs pour collecter les métriques système en temps réel."

Ouvrir dans le navigateur : http://localhost:3000

"On voit le dashboard Node Exporter Full qui affiche les métriques CPU, mémoire et disque des 2 serveurs. Dans le menu Job en haut on peut switcher entre k3s-server et monitoring."

---

## ÉTAPE 8 — Conclusion
"La VM se crée automatiquement avec Vagrant, l'image Docker est buildée et déployée via GitHub Actions avec un runner self-hosted, Kubernetes gère la haute disponibilité, et les données MySQL sont persistantes."

---


---

## Structure du projet

```
devops/
├── app/                    
│   ├── server.js
│   ├── package.json
│   ├── Dockerfile
│   └── .dockerignore
├── k8s/                    
│   ├── api-deployment.yaml
│   └── mysql-deployment.yaml
├── scripts/
│   └── get_ip.sh           
├── ansible/
│   └── playbook.yml        
├── demo.sh                 
├── Vagrantfile             
└── .github/workflows/
    └── ci-cd.yml           
```
## Lancer la démo complète

```bash
cd ~/devops
bash demo.sh
```
## Note sur le code source

Le repo original du TP (https://github.com/almoggutin/Node-Express-RESTAPI-MySQL-JS-Example) n'était plus disponible au moment du développement. Une API Node.js/Express/MySQL équivalente a donc été développée from scratch avec les mêmes fonctionnalités : gestion des lacets connectés avec les routes GET, POST et DELETE.
# trigger
