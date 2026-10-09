# blogcode
Code examples to accompany blog posts on nickromney.com

## Executable example index

| Example | Source/environment | Local acceptance | Deployment boundary |
| --- | --- | --- | --- |
| Azure Functions Python API | `python-api-azure-functions/main.py`; `pyproject.toml` and `uv.lock` in that directory | `uv run --locked --directory python-api-azure-functions pytest` (see [AGENTS.md](AGENTS.md)) | Separate Azure Function target; local tests do not prove host packaging or live invocation |

Examples remain independent packages. Add one row for a new post and keep its
runtime, tests and deployment recipe inside the package.
