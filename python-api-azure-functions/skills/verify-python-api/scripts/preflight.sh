#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:?usage: preflight.sh PROJECT_ROOT}"
for command in python3 curl; do
  if ! command -v "$command" >/dev/null 2>&1; then
    echo "FAIL: required local command missing: $command" >&2
    exit 1
  fi
done
for required in pyproject.toml uv.lock .venv/bin/python .venv/bin/uvicorn; do
  if [ ! -e "$ROOT/$required" ]; then
    echo "FAIL: required locked project input or existing environment missing: $ROOT/$required" >&2
    exit 1
  fi
done
"$ROOT/.venv/bin/python" "$ROOT/skills/verify-python-api/scripts/check-runtime.py" "$ROOT"
