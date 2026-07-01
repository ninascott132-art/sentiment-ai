from fastapi.testclient import TestClient
from src.main import app

client = TestClient(app)


# Test 1 : Vérification de l'endpoint technique obligatoire /health (Attendu par le sujet)
def test_health_endpoint():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


# Test 2 : Vérification fonctionnelle de la route de prédiction métier
def test_predict_positive():
    response = client.post(
        "/predict", json={"text": "Ce projet de groupe DevOps est fantastique !"}
    )
    assert response.status_code == 200
    assert "label" in response.json()
    assert "score" in response.json()


# Test 3 : Vérification de la robustesse face aux entrées incorrectes
def test_predict_empty_text():
    response = client.post("/predict", json={"text": ""})
    # Valide que l'API gère le cas correctement (code 200 ou blocage 422 selon ton schéma)
    assert response.status_code in [200, 422]
