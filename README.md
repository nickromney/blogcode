# blogcode
Code examples to accompany blog posts on nickromney.com

## Agent operation and plan status

For the current ownership, action-effect and evidence contracts, use [the operating model](docs/agent-system.md). Its implemented plan covers agent navigation and documentation. Feature proposals below remain proposals until their own acceptance evidence is recorded; dated observations retain their original scope.

## Executable example index

| Example | Source/environment | Local acceptance | Deployment boundary |
| --- | --- | --- | --- |
| Azure Functions Python API | `python-api-azure-functions/main.py`; `pyproject.toml` and `uv.lock` in that directory | `cd python-api-azure-functions && uv run --offline pytest` when environment/dependencies are available; `tests/test_api.py` | Separate Azure Function target, deployment revision and dated response check |

Examples remain independent packages. Add one row for a new post and keep its
runtime, tests and deployment recipe inside the package. A local FastAPI fixture
pass does not prove Azure Function host packaging or live invocation.
