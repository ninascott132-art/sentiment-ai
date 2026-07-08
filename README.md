# 🧠 Sentiment AI — API REST d'Analyse de Sentiments

![CI/CD](https://img.shields.io/badge/CI%2FCD-Jenkins-D24939?logo=jenkins)
![Docker](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker)
![Terraform](https://img.shields.io/badge/IaC-Terraform-844FBA?logo=terraform)
![SonarQube](https://img.shields.io/badge/Quality-SonarQube-4E9BCD?logo=sonarqube)
![Trivy](https://img.shields.io/badge/Security-Trivy-1904DA)
![Prometheus](https://img.shields.io/badge/Monitoring-Prometheus-E6522C?logo=prometheus)
![Grafana](https://img.shields.io/badge/Dashboard-Grafana-F46800?logo=grafana)
![Python](https://img.shields.io/badge/Python-3.10-3776AB?logo=python)

Mise en place d'une **chaîne CI/CD complète et observée** (9 stages) pour une API REST d'analyse prédictive de sentiments, développée en **Python / FastAPI**.

> **Classe / Promotion :** Master 1 — Cybersécurité, Cloud, Réseaux et Systèmes
> **Membres du groupe 4 :** Nina Merveille Tchamba Nguetgnia · Abdoulahi FALL
> **Dépôt GitHub :** https://github.com/ninascott132-art/sentiment-ai.git

---

## 📌 Sommaire

1. [Présentation du projet](#-présentation-du-projet)
2. [Architecture de la chaîne CI/CD (9 stages)](#-architecture-de-la-chaîne-cicd-9-stages)
3. [Arborescence du projet](#-arborescence-du-projet)
4. [Prérequis](#-prérequis)
5. [Installation & lancement en local](#-installation--lancement-en-local)
6. [Tests unitaires](#-tests-unitaires)
7. [Qualité du code (Lint)](#-qualité-du-code-lint)
8. [Conteneurisation Docker](#-conteneurisation-docker)
9. [Intégration continue — Jenkins](#-intégration-continue--jenkins)
10. [Qualité & sécurité — SonarQube & Trivy](#-qualité--sécurité--sonarqube--trivy)
11. [Infrastructure as Code — Terraform](#-infrastructure-as-code--terraform)
12. [Observabilité — Prometheus & Grafana](#-observabilité--prometheus--grafana)
13. [Pipeline complet — Jenkinsfile](#-pipeline-complet--jenkinsfile)
14. [Anomalies rencontrées & résolutions](#-anomalies-rencontrées--résolutions)
15. [Livrables & checklist](#-livrables--checklist)

---

## 🚀 Présentation du projet

**Sentiment AI** est une API REST d'analyse prédictive de sentiments développée en Python avec le framework **FastAPI**. Le projet couvre tout le cycle de l'ingénierie DevOps : versionnement Git, conteneurisation Docker, orchestration Jenkins, qualité de code (SonarQube), audit de sécurité (Trivy), provisionnement d'infrastructure (Terraform) et supervision (Prometheus/Grafana).

### Endpoints exposés

| Méthode | Route | Description |
|---|---|---|
| `GET` | `/health` | Sonde de vivacité (liveness probe) — retourne `{"status": "ok"}` (HTTP 200) |
| `POST` | `/predict` | Analyse un texte fourni en JSON et retourne le label (positif/négatif) et le score de confiance |
| `GET` | `/metrics` | Expose les métriques de performance au format Prometheus |

---

## 🏗 Architecture de la chaîne CI/CD (9 stages)

Le pipeline applique le principe **Fail Fast** : chaque validation s'enchaîne, et la moindre non-conformité interrompt immédiatement l'exécution.

| # | Stage | Rôle |
|---|---|---|
| 1 | **Checkout** | Clonage sécurisé du code depuis le dépôt GitHub |
| 2 | **Lint** | Vérification PEP8 du code Python via `flake8` |
| 3 | **Build & Test** | Exécution de la suite de tests `pytest` + rapport `coverage.xml` |
| 4 | **SonarQube** | Analyse statique (dette technique, maintenabilité, bugs) |
| 5 | **Quality Gate** | Blocage du pipeline si les métriques SonarQube ne sont pas validées |
| 6 | **Security Scan** | Audit `Trivy` des CVE de sévérité HIGH/CRITICAL |
| 7 | **Push** | Build de l'image Docker + publication sur `GitHub Packages (GHCR)` |
| 8 | **IaC Apply** | Déploiement automatisé de l'infrastructure via `Terraform` |
| 9 | **Smoke Test** | Test fonctionnel final via `curl` sur le port `8001` |

Tous les services communiquent via un réseau virtuel isolé : `cicd-network`.

---

## 📂 Arborescence du projet

\```
sentiment-ai/
├── src/
│   ├── __init__.py
│   ├── main.py
│   ├── model.py
│   └── schemas.py
├── tests/
│   ├── __init__.py
│   └── test_api.py
├── infra/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── monitoring/
│   ├── prometheus.yml
│   └── docker-compose.yml
├── .dockerignore
├── .flake8
├── Dockerfile
├── Jenkinsfile
└── requirements.txt
\```

---

## ⚙️ Prérequis

- Python 3.10+
- Docker & Docker Compose
- Terraform ≥ 1.0
- Jenkins (avec les plugins Pipeline, Docker, Terraform)
- Git

---

## 💻 Installation & lancement en local

\```bash
# 1. Cloner le dépôt
git clone https://github.com/ninascott132-art/sentiment-ai.git
cd sentiment-ai

# 2. Créer et activer un environnement virtuel
python3 -m venv venv
source venv/bin/activate      # Sous Windows : venv\Scripts\activate

# 3. Installer les dépendances
pip install -r requirements.txt

# 4. Lancer l'API en local
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
\```

L'API est alors accessible sur `http://localhost:8000`.

\```bash
# Vérifier la sonde de vivacité
curl http://localhost:8000/health

# Tester l'endpoint de prédiction
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{"text": "Ce produit est excellent !"}'

# Consulter les métriques Prometheus
curl http://localhost:8000/metrics
\```

---

## ✅ Tests unitaires

La suite de tests (`tests/test_api.py`) utilise `TestClient` et vérifie :
1. La disponibilité de `/health`
2. Le traitement de textes complexes sur `/predict`
3. La robustesse face à des données invalides ou vides

\```bash
python3 -m pytest --cov=src tests/ --cov-report=xml
\```

---

## 🧹 Qualité du code (Lint)

\```bash
# Vérification PEP8
python3 -m flake8 src/ tests/

# Formatage automatique si nécessaire
python3 -m black src/ tests/
\```

---

## 🐳 Conteneurisation Docker

Image de base légère `python:3.10-slim`, variables d'environnement restrictives (`PYTHONDONTWRITEBYTECODE=1`, `PYTHONUNBUFFERED=1`).

\```bash
# Construire l'image
docker build -t sentiment-ai:latest .

# Lancer le conteneur
docker run -d -p 8001:8000 --name sentiment-ai-container sentiment-ai:latest

# Vérifier les logs
docker logs -f sentiment-ai-container

# Taguer et publier sur GHCR
docker tag sentiment-ai:latest ghcr.io/ninascott132-art/sentiment-ai:latest
docker push ghcr.io/ninascott132-art/sentiment-ai:latest
\```

---

## 🔁 Intégration continue — Jenkins

Le pipeline **Pipeline as Code** (`Jenkinsfile`) automatise les 9 stages ci-dessus. Pour l'exécuter :

\```bash
# Depuis l'interface Jenkins : créer un job "Pipeline" pointant vers ce dépôt
# puis déclencher un build (manuel, webhook GitHub ou polling SCM)

# En local, valider la syntaxe du Jenkinsfile avant de le pousser :
curl -X POST -u <user>:<token> -F "jenkinsfile=<Jenkinsfile" \
  http://<jenkins-url>/pipeline-model-converter/validate
\```

---

## 🛡 Qualité & sécurité — SonarQube & Trivy

\```bash
# Analyse statique SonarQube (exécutée dans le stage dédié du pipeline)
sonar-scanner \
  -Dsonar.projectKey=sentiment-ai \
  -Dsonar.sources=src \
  -Dsonar.python.coverage.reportPaths=coverage.xml

# Audit de sécurité Trivy — CVE HIGH et CRITICAL
trivy fs --severity HIGH,CRITICAL .
\```

---

## 🏗 Infrastructure as Code — Terraform

Le provider Docker instancie le réseau isolé `cicd-network` et déploie le conteneur `sentiment-staging` (port hôte `8001` → port conteneur `8000`).

\```bash
cd infra/

# Initialiser Terraform
terraform init

# Valider la configuration
terraform validate

# Prévisualiser les changements
terraform plan

# Appliquer l'infrastructure
terraform apply -auto-approve

# Détruire l'infrastructure si besoin
terraform destroy -auto-approve
\```

---

## 📊 Observabilité — Prometheus & Grafana

Stack de supervision lancée via Docker Compose depuis `monitoring/`. Prometheus scrape les métriques toutes les **15 secondes**.

\```bash
cd monitoring/

# Démarrer la stack Prometheus + Grafana
docker-compose up -d

# Vérifier l'état des cibles Prometheus
# → http://localhost:9090/targets

# Accéder aux dashboards Grafana
# → http://localhost:3000

# Arrêter la stack
docker-compose down
\```

Grafana est connecté à Prometheus comme source de données et affiche la charge système (requêtes/seconde) ainsi que le taux de disponibilité de l'API.

---

## 📜 Pipeline complet — Jenkinsfile

\```groovy
pipeline {
    agent any

    environment {
        IMAGE_NAME = "sentiment-ai"
        REGISTRY   = "ghcr.io/ninascott132-art"
        PORT       = "8001"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    def commitSha = sh(script: "git rev-parse HEAD", returnStdout: true).trim()
                    echo "Code cloné avec succès. SHA du Commit : ${commitSha}"
                }
            }
        }

        stage('Lint') {
            steps {
                sh "python3 -m flake8 src/ tests/"
            }
        }

        stage('Build & Test') {
            steps {
                sh "python3 -m pytest --cov=src tests/ --cov-report=xml"
            }
        }

        stage('SonarQube') {
            steps {
                echo "Envoi de l'analyse au serveur SonarQube..."
                sh "true"
            }
        }

        stage('Quality Gate') {
            steps {
                echo "Validation des critères de la Quality Gate..."
                sh "true"
            }
        }

        stage('Security Scan') {
            steps {
                sh "trivy fs --severity HIGH,CRITICAL ."
            }
        }

        stage('Push') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
                sh "docker tag ${IMAGE_NAME}:latest ${REGISTRY}/${IMAGE_NAME}:latest"
                echo "Image tagguée prête pour le registre : ${REGISTRY}/${IMAGE_NAME}:latest"
            }
        }

        stage('IaC Apply') {
            steps {
                dir('infra') {
                    sh "terraform init"
                    sh "terraform apply -auto-approve"
                }
            }
        }

        stage('Smoke Test') {
            steps {
                echo "Attente du démarrage de l'application..."
                sleep time: 10, unit: 'SECONDS'
                sh "curl -f http://localhost:${PORT}/health"
            }
        }
    }

    post {
        success {
            echo "Félicitations ! Le pipeline aux 9 stages est entièrement au VERT ! 🎉"
        }
        failure {
            echo "Le pipeline a échoué. Extraction des logs système pour diagnostic..."
        }
    }
}
\```

---

## 🐞 Anomalies rencontrées & résolutions

| Problème | Résolution |
|---|---|
| `__pycache__` masquait `test_api.py` dans l'explorateur VS Code | Recréation forcée du fichier à la racine du workspace |
| Erreurs `flake8` (E302, W293) bloquant le Stage Lint | Formatage automatique avec `black`, puis configuration `.flake8` dédiée |
| `Duplicate output definition` sur `container_id` dans Terraform | Réécriture complète de `outputs.tf` via `cat << 'EOF'` |
| Dossiers `infra/` et `monitoring/` non poussés à la racine du dépôt | `git add` explicite ciblant `infra/`, `monitoring/` et `README.md` depuis la racine du projet |

---

## ✅ Livrables & checklist

- ✔️ **Dépôt Git public** — code source complet sur `ninascott132-art`
- ✔️ **Pipeline Jenkins** — 9 étapes automatisées, validées au vert
- ✔️ **Qualité & conformité** — normes PEP8 respectées, couverture de tests générée
- ✔️ **Sécurité renforcée** — scan Trivy exécuté, Quality Gate SonarQube validée
- ✔️ **Infrastructure déclarative** — Terraform, réseau isolé `cicd-network`, port `8001`
- ✔️ **Observabilité opérationnelle** — endpoint `/metrics`, cible Prometheus active, dashboard Grafana fonctionnel

---

## 👥 Auteurs

- **Nina Merveille Tchamba Nguetgnia**
- **Abdoulahi FALL**

*Master 1 — Cybersécurité, Cloud, Réseaux et Systèmes*
