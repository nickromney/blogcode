#!/usr/bin/env bats

setup() {
  SKILL_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  SCRIPT="$SKILL_DIR/scripts/control.sh"
  BASH32="${VERIFY_TEST_BASH:-/bin/bash}"
  export VERIFY_BASE_DIR="$BATS_TEST_TMPDIR/base"
  export VERIFY_EVIDENCE_ROOT="$BATS_TEST_TMPDIR/evidence"
  export VERIFY_RUN_ID="api-refusal"
}

@test "doctor fails before launch without creating state or evidence" {
  run "$BASH32" "$SCRIPT" --execute doctor
  [ "$status" -ne 0 ]
  [[ "$output" == *"not running"* ]]
  [ ! -e "$VERIFY_BASE_DIR" ]
  [ ! -e "$VERIFY_EVIDENCE_ROOT" ]
}
