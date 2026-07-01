output "app_url" {
  value       = "http://localhost:8001"
  description = "L'URL d'accès à l'application de Staging"
}

output "container_id" {
  value       = docker_container.sentiment_staging.id
  description = "L'ID du conteneur déployé"
}

output "network_name" {
  value       = docker_network.cicd_net.name
  description = "Le nom du réseau isolé utilisé"
}
