
IMAGE_NAME = sentiment-ai
PORT       = 8080

.PHONY: build run test stop clean tag

# Construire l'image Docker de l'API
build:
	docker build -t $(IMAGE_NAME):latest .

# Lancer la stack avec Docker Compose
run:
	docker compose up -d

# Lancer les tests unitaires à l'intérieur du conteneur temporaire (Étape 4.2)
test:
	docker run --rm \
		-v $$(pwd):/app \
		-w /app \
		$(IMAGE_NAME):latest \
		pytest tests/ -v --cov=src --cov-report=term-missing

# Arrêter les conteneurs lancés par Docker Compose
stop:
	docker compose down

# Tout nettoyer : conteneurs Docker Compose et l'image principale
clean:
	docker compose down
	docker rmi $(IMAGE_NAME):latest || true