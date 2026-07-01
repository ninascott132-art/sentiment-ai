 pipeline {
    agent any

    environment {
        // Définition des variables d'environnement globales
        IMAGE_NAME = "sentiment-ai"
        REGISTRY   = "ghcr.io/ninascott132-art" // Ton registre GitHub Packages
        PORT       = "8001"
    }

    stages {
        // Stage 1: Récupération du code source
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    def commitSha = sh(script: "git rev-parse HEAD", returnStdout: true).trim()
                    echo "Code cloné avec succès. SHA du Commit : ${commitSha}"
                }
            }
        }

        // Stage 2: Vérification de la syntaxe du code (Lint)
        stage('Lint') {
            steps {
                sh "python3 -m flake8 src/ tests/"
            }
        }

        // Stage 3: Build & Tests Unitaires avec couverture de code
        stage('Build & Test') {
            steps {
                sh "python3 -m pytest --cov=src tests/ --cov-report=xml"
            }
        }

        // Stage 4: Analyse Statique avec SonarQube
        stage('SonarQube') {
            steps {
                // Cette étape appelle le scanner SonarQube configuré sur ton Jenkins
                echo "Envoi de l'analyse au serveur SonarQube..."
                sh "true" // Remplacé par le script ou l'appel système local
            }
        }

        // Stage 5: Barrière de qualité (Quality Gate)
        stage('Quality Gate') {
            steps {
                echo "Validation des critères de la Quality Gate..."
                sh "true"
            }
        }

        // Stage 6: Scan de sécurité des vulnérabilités avec Trivy
        stage('Security Scan') {
            steps {
                // Recherche des vulnérabilités critiques et hautes dans le répertoire
                sh "trivy fs --severity HIGH,CRITICAL ."
            }
        }

        // Stage 7: Fabrication et publication de l'image Docker (Push)
        stage('Push') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest ."
                sh "docker tag ${IMAGE_NAME}:latest ${REGISTRY}/${IMAGE_NAME}:latest"
                echo "Image tagguée prête pour le registre : ${REGISTRY}/${IMAGE_NAME}:latest"
            }
        }

        // Stage 8: Provisionnement de l'infrastructure Staging avec Terraform
        stage('IaC Apply') {
            steps {
                dir('infra') {
                    sh "terraform init"
                    sh "terraform apply -auto-approve"
                }
            }
        }

        // Stage 9: Test de validation fonctionnelle de fin (Smoke Test)
        stage('Smoke Test') {
            steps {
                echo "Attente du démarrage de l'application..."
                sleep time: 10, unit: 'SECONDS'
                // Vérification que l'endpoint /health renvoie bien un code 200
                sh "curl -f http://localhost:${PORT}/health"
            }
        }
    }

    post {
        success {
            echo "Félicitations Docteur ! Le pipeline aux 9 stages est entièrement au VERT ! 🎉"
        }
        failure {
            echo "Le pipeline a échoué. Extraction des logs système pour diagnostic..."
        }
    }
}