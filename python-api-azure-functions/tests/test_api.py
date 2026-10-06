from fastapi.testclient import TestClient
from main import app


def test_name_contract():
    with TestClient(app) as client:
        for _ in range(20):
            response = client.get("/v1/generate_name")
            assert response.status_code == 200
            assert response.headers["content-type"].startswith("application/json")
            body = response.json()
            assert set(body) == {"name"}
            assert body["name"] in {"Minnie", "Margaret", "Myrtle"}


def test_unknown_route():
    with TestClient(app) as client:
        assert client.get("/v1/missing").status_code == 404
