# 🧠 Pipeline CI/CD DevOps End-to-End & Observabilité — Sentiment AI

Ce dépôt rassemble l'intégralité des travaux pratiques et des livrables requis pour le module DevOps (Projets 1 à 6). Il présente une architecture complète allant du versionnement d'une API REST jusqu'à son déploiement automatisé et sa supervision en temps réel.

## 👥 Informations du Projet
* **Auteur :** Nina Merveille Tchamba Nguetgnia
* **Établissement :** ESTIAM Institute
* **Parcours :** Master 2 — Cybersécurité, Cloud, Réseaux et Systèmes
* **Application Cible :** Sentiment AI API (FastAPI)

---

## 🏗️ Synthèse des Réalisations (Projets 1 à 6)

### 🔹 Projet 1 & 2 : Gestion de Version (Git) et Conteneurisation (Docker)
* **Git :** Structuration rigoureuse des branches et historique de commits atomique respectant les standards industriels.
* **Docker :** Création d'un `Dockerfile` optimisé basé sur une image de confiance légère (`python:3.10-slim`). Gestion des caches de calques pour accélérer le build et réduction de la surface d'attaque.

### 🔹 Projet 3 : Intégration Continue (Jenkins Pipeline)
* Implémentation d'un pipeline déclaratif industrialisé sous forme de code (`Jenkinsfile`) orchestrant la totalité de la chaîne selon le principe du *Fail Fast*.

### 🔹 Projet 4 : Qualité du Code & Sécurité (SonarQube & Trivy)
* **SonarQube :** Analyse statique automatisée du code source avec validation stricte de la *Quality Gate* (Couverture, Dette technique, Bugs).
* **Trivy :** Scan de sécurité autonome du système de fichiers et des dépendances logicielles pour interdire le déploiement de vulnérabilités critiques (CVE).

### 🔹 Projet 5 : Infrastructure as Code (Terraform)
* Déclaration et provisionnement de l'infrastructure de Staging dans le dossier `infra/`.
* Isolation réseau via la création du réseau virtuel hermétique `cicd-network`.
* Déploiement automatique du conteneur applicatif avec redirection du port **8001** de l'hôte vers le port interne **8000**.

### 🔹 Projet 6 : Observabilité & Supervision (Prometheus & Grafana)
* **Prometheus :** Configuration d'un scrape job (`monitoring/prometheus.yml`) collectant les métriques de performance exposées sur l'endpoint `/metrics` toutes les 15 secondes.
* **Grafana :** Centralisation et mise en œuvre de tableaux de bord dynamiques pour visualiser la charge de l'API (requêtes par seconde) et sa disponibilité opérationnelle.

---

## 🗂️ Structure du Dépôt
```text
sentiment-ai/
├── src/               # Code source de l'API FastAPI (Projets 1 & 2)
├── tests/             # Suite de tests unitaires (Projet 2)
├── infra/             # Configuration Infrastructure as Code Terraform (Projet 5)
├── monitoring/        # Stack d'observabilité Prometheus/Grafana (Projet 6)
├── .flake8            # Configuration du linter de conformité PEP8 (Projet 2)
├── Dockerfile         # Recette de conteneurisation optimisée (Projet 2)
├── Jenkinsfile        # Pipeline d'automatisation à 9 stages (Projets 3 & 4)
└── requirements.txt   # Dépendances logicielles du projet
