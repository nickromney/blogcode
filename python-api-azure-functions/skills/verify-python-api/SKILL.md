---
name: verify-python-api
description: Start the local FastAPI example and verify the name-generation HTTP contract through real loopback requests.
---

# Verify the Python API example

Run `make verify-dry-run` to inspect the plan, `make verify-test` for the
verify-kit contracts, and `make verify` to launch the locked local FastAPI
environment and exercise the HTTP interface. The run does not call Azure or
install packages. Preflight requires the existing `.venv`, `uv.lock`, and
installed FastAPI/Uvicorn versions matching the lock.

The harness starts only this run's Uvicorn process bound to `127.0.0.1` on an
allocated port. It makes 20 `GET /v1/generate_name` requests, checking status,
JSON content type, response keys, and the documented set of names, then checks
that an unknown route returns 404. The exact observed responses are kept in
`api-responses.json` beneath `$VERIFY_EVIDENCE_ROOT/$VERIFY_RUN_ID`. State,
including the server PID and URL, is nested under
`$VERIFY_BASE_DIR/$VERIFY_RUN_ID/state` and removed during cleanup. The server
log and revision snapshot remain in evidence.

This proves the local ASGI HTTP path and response contract. It does not prove
Azure Functions host packaging, cloud deployment, or a live Azure invocation.
