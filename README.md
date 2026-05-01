
# DevOps TP Final - Lacets Connectés API

## Prérequis
- VirtualBox
- Vagrant
- Git

## Structure du projet
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
├── Vagrantfile
└── .github/workflows/
└── ci-cd.yml
## Partie 1 - Infrastructure

### Démarrer la VM
```bash
vagrant up
```

### Récupérer l'IP et générer l'inventaire Ansible
```bash
bash scripts/get_ip.sh
```

## Partie 2 - Docker

Image disponible sur Docker Hub : `awesso/laces-api:latest`

### Build manuel
```bash
docker build -t awesso/laces-api:latest ./app
```

## Partie 3 - Kubernetes

### Déployer sur k3s
```bash
vagrant ssh
sudo kubectl apply -f /vagrant/k8s/
sudo kubectl get all
```

### Tester l'API
```bash
sudo kubectl exec -it <pod-name> -- wget -qO- http://localhost:3000/health
```

## Partie 4 - CI/CD

Pipeline GitHub Actions automatique sur push sur `main` :
1. Build de l'image Docker
2. Push sur Docker Hub (`awesso/laces-api:latest`)

## Notes
- API accessible uniquement depuis l'intérieur du cluster (ClusterIP)
- MySQL utilise un PersistentVolumeClaim pour la persistance des données
- HPA configuré : min 1 pod, max 3 pods (seuil CPU/RAM 70%)
# update
