
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {}

# 1. Déclaration du réseau isolé obligatoire 'cicd-network'
resource "docker_network" "cicd_net" {
  name = "cicd-network"
}

# 2. Déclaration du conteneur applicatif de Staging
resource "docker_container" "sentiment_staging" {
  name  = "sentiment-staging"
  image = "ghcr.io/ninascott132-art/sentiment-ai:latest"

  # Attachement au réseau isolé
  networks_advanced {
    name = docker_network.cicd_net.name
  }

  # Mappage du port 8001 requis pour le Staging et le Monitoring
  ports {
    internal = 8000
    external = 8001
  }

  # Redémarrage automatique en cas de crash
  restart = "always"
}