# Local API example

This runnable companion to the Python API/Azure Functions article exposes
`GET /v1/generate_name`, returning JSON with one `name` chosen from Minnie,
Margaret and Myrtle. It runs FastAPI locally; it does not provision Azure.

```sh
cd python-api-azure-functions
uv sync --group dev
uv run pytest
uv run fastapi dev main.py
curl http://127.0.0.1:8000/v1/generate_name
```

For an isolated local HTTP verification cycle, run `make verify-dry-run`,
`make verify-test`, then `make verify`. The harness uses the existing `.venv`
only when its FastAPI and Uvicorn versions match `uv.lock`; it does not install
packages or contact Azure. It saves the observed JSON responses under the
verify-kit evidence path and stops its own server during cleanup.

The TestClient contract exercises JSON shape, supported values and a missing
route without starting a network listener or calling an Azure endpoint.
