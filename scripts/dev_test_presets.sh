#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/lib/util.sh"

run_test() {
  local name=$1
  local input=$2
  local expected=$3
  local output
  output=$(parse_presets_tsv <<<"$input")
  if [[ "$output" != "$expected" ]]; then
    printf 'FAIL: %s\n' "$name" >&2
    printf 'Expected:\n%s\n' "$expected" >&2
    printf 'Got:\n%s\n' "$output" >&2
    exit 1
  fi
  printf 'ok: %s\n' "$name"
}

run_test "object-with-nulls" \
  '{"1":{"n":"Warm White"},"2":null,"3":{"n":"Party"},"10":{}}' \
  $'1\tWarm White\n3\tParty\n10\tPreset 10'

run_test "array-shape" \
  '["Sunrise",null,"Evening"]' \
  $'0\tSunrise\n2\tEvening'

run_test "unrecognized" \
  '"oops"' \
  ''
