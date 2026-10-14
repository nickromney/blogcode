#!/usr/bin/env bash
# shellcheck disable=SC2034 # VK_* settings are read by the sourced verify-lib.sh
set -euo pipefail

VK_SCRIPT="$0"
VK_APP="blogcode-python-api"
VK_DESCRIPTION="Start the local FastAPI example and verify its name-generation HTTP endpoint."
VK_DEFAULT_BASE_DIR="${TMPDIR:-/tmp}/verify-blogcode-python-api-state"
VK_DEFAULT_EVIDENCE_ROOT="${TMPDIR:-/tmp}/verify-blogcode-python-api-evidence"
# shellcheck source=verify-lib.sh disable=SC1091
. "$(cd "$(dirname "$0")" && pwd)/verify-lib.sh"

vk_commands_help() {
  cat <<'HELP'
  launch    start this run's API server on loopback
  doctor    call the name endpoint and an unknown route, then verify their responses
  cleanup   stop this run's API server and remove its state
HELP
}
vk_sample_commands() { printf '%s\n' verify launch doctor cleanup; }
vk_paths() {
  STATE="$VK_BASE_DIR/$VK_RUN_ID/state"
  EVIDENCE="$VK_EVIDENCE_ROOT/$VK_RUN_ID"
  APP_ROOT="$(cd "$VK_SKILL_DIR/../.." && pwd)"
  VENV="$APP_ROOT/.venv"
  URL=""
  if [ -f "$STATE/url" ]; then URL="$(cat "$STATE/url")"; fi
}

vk_plan() {
  case "$1" in
    verify) vk_plan_line "check the existing locked Python runtime; launch FastAPI on loopback; assert repeated JSON values and a 404 route response; stop this server and retain evidence at $EVIDENCE" ;;
    launch) vk_plan_line "verify the existing project environment against uv.lock and start the FastAPI server on an allocated loopback port" ;;
    doctor) vk_plan_line "GET /v1/generate_name repeatedly and an unknown route at $URL; assert JSON shape, allowed names, content type, and 404" ;;
    cleanup) vk_plan_line "stop only this run's FastAPI process group, remove its state, and preserve evidence at $EVIDENCE" ;;
    *) vk_unknown_command ;;
  esac
}

allocate_port() {
  python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1", 0)); print(s.getsockname()[1]); s.close()'
}

cmd_launch() {
  mkdir -p "$EVIDENCE"
  /bin/bash "$VK_SKILL_DIR/scripts/preflight.sh" "$APP_ROOT" > "$EVIDENCE/preflight.log" 2>&1 || {
    cat "$EVIDENCE/preflight.log" >&2
    vk_fail "project runtime preflight failed; see $EVIDENCE/preflight.log"
    return 1
  }
  local port
  mkdir -p "$STATE" "$EVIDENCE"
  vk_mark_current
  vk_record_revision "$EVIDENCE/revision.txt"
  port="$(allocate_port)"
  URL="http://127.0.0.1:$port"
  printf '%s\n' "$URL" > "$STATE/url"
  vk_spawn_group "$STATE/server.pid" "$EVIDENCE/server.log" \
    "$VENV/bin/uvicorn" main:app --app-dir "$APP_ROOT" --host 127.0.0.1 --port "$port"
  vk_wait_for_alive "$STATE/server.pid" 30 curl -fsS -o /dev/null "$URL/v1/generate_name" || {
    cat "$EVIDENCE/server.log" >&2
    vk_fail "FastAPI did not become ready; see $EVIDENCE/server.log"
    return 1
  }
  vk_say "ready run=$VK_RUN_ID url=$URL evidence=$EVIDENCE"
}

cmd_doctor() {
  if [ ! -f "$STATE/server.pid" ]; then
    vk_fail "this run's FastAPI server is not running; launch first"
    return 1
  fi
  if ! vk_group_alive "$STATE/server.pid"; then
    vk_fail "this run's FastAPI server is not running; launch first"
    return 1
  fi
  [ -n "$URL" ] || { vk_fail "run URL missing; launch first"; return 1; }
  curl -fsS -o /dev/null "$URL/v1/generate_name" || {
    vk_fail "the owned FastAPI server did not return a successful health response"
    return 1
  }
}

vk_verify_recipes() {
  if ! "$VENV/bin/python" "$VK_SKILL_DIR/scripts/check-api.py" "$URL" "$EVIDENCE/api-responses.json" \
    > "$EVIDENCE/api-check.log" 2>&1; then
    cat "$EVIDENCE/api-check.log" >&2
    vk_fail "the live HTTP response assertions failed; see $EVIDENCE/api-check.log"
    return 1
  fi
  vk_expect_contains "$EVIDENCE/api-check.log" "PASS: 20 JSON responses matched the name contract; unknown route returned HTTP 404"
  vk_expect_file "$EVIDENCE/api-responses.json"
}

cmd_cleanup() {
  if [ -f "$STATE/server.pid" ]; then vk_stop_group "$STATE/server.pid"; fi
  rm -rf "${STATE:?}"
  rmdir "$VK_BASE_DIR/$VK_RUN_ID" 2>/dev/null || true
  vk_clear_current
  vk_say "stopped this run's FastAPI server and removed run state; evidence kept at $EVIDENCE"
}

vk_dispatch() {
  local cmd="$1"
  shift
  case "$cmd" in
    launch) cmd_launch ;;
    doctor) cmd_doctor ;;
    cleanup) cmd_cleanup ;;
    *) vk_unknown_command ;;
  esac
}

vk_main "$@"
