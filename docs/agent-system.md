# blogcode: agent operating model

Adopted 6 October 2026 from local source and command inspection.
Small independent executable examples accompanying blog posts.

## Read by intent

Start with the local agent guide and build manifest. For domain or behavior
changes, follow the owners below, then the relevant contract/test. These
documents retain product detail and historical evidence:

- [python-api-azure-functions/README.md](../python-api-azure-functions/README.md)
- [README.md](../README.md)

## System ownership

| Owner | Responsibility |
| --- | --- |
| [README.md](../README.md) | Index of teaching examples. |
| [python-api-azure-functions/main.py](../python-api-azure-functions/main.py) | Example API and its dependency owner. |
| [python-api-azure-functions/pyproject.toml](../python-api-azure-functions/pyproject.toml) | Example API and its dependency owner. |
| [python-api-azure-functions/tests](../python-api-azure-functions/tests) | Focused API behavior proof. |

Intent selects the owning policy; that policy produces decisions or artifacts;
adapters perform effects; verification establishes the result. Change the
owner once and keep alternate surfaces on that same contract.

## Invariants

- Examples are independent, not a shared deployment platform.

## Existing action interfaces

These are inspected command surfaces, not a report that they ran. Read current
help and recipes for arguments, dependencies and lifecycle hooks before use.
Examples containing placeholder paths or bracketed options are grammar.

| Command | Effects and evidence |
| --- | --- |
| `cd python-api-azure-functions && uv run pytest` | Example tests; dependency sync can download packages if absent. |

## Observe, verify and retain

Establish source revision, dirty state and relevant input identity before
choosing an action. Keep intended settings, cached artifacts and observed
runtime state distinct. An existing artifact is not a freshness or readiness
claim. Use the smallest deterministic fixture at the changed seam first;
expand to process, browser, device or deployment checks only when that
claim needs them. Record unavailable evidence explicitly.

Retain the command/configuration, source and input identity, result, limitation
and next discriminating check. Reuse evidence only while its relevant inputs
remain applicable. Promote a reproducible failure to a regression fixture,
a design decision to its owning document, and a repeated operator correction
to one concise guide rule. Keep private observations in private artifacts.

## Implemented plan for this pass

- [x] Map current source ownership and existing interfaces.
- [x] Make command effects and evidence limits discoverable.
- [x] Route agent work here and retain detailed product plans at their owners.

Acceptance: owner paths and document links resolve; current instructions
match inspected source; catalog hashes bind this context to the reviewed
bytes. This is documentation/control navigation acceptance. Product runtime
checks retain their own scope and are not certified by this pass.

## Project decisions

Work inside the individual example package. python-api-azure-functions/main.py owns the example API and pyproject.toml/uv.lock own its environment; tests/test_api.py owns local behavior evidence. Run that package's tests before claiming an example works. Azure deployment is a separate acceptance step requiring a named target and dated response evidence. When adding another post, add one index link with source path, prerequisites, local command and deployed-test boundary rather than introducing repository-wide orchestration.
