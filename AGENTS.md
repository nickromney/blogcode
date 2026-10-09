# blogcode agent guide

Small independent code examples for blog posts. Each example is its own package.

## Verify

- Pre-push gate: `lefthook run pre-push --force`. It runs
  `uv run --locked --directory python-api-azure-functions pytest`. A plain
  manual run can select no files. No GitHub Actions workflow is active.
- Dependency sync can download packages if they are not already present.

## Hazards

- Local pytest runs use FastAPI test clients. They do not prove Azure Functions
  host packaging or live invocation. Deployment is a separate step with a named
  target and dated response check.
