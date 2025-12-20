#!/usr/bin/env bash
set -euo pipefail
shopt -s lastpipe
IFS=$'\n\t'

source "$(dirname "${BASH_SOURCE[0]}")/util.sh"

API_CONNECT_TIMEOUT=1
API_MAX_TIME=2

api_base_url() {
  local id=$1
  printf 'http://%s:%s' "${DEV_HOST[$id]}" "${DEV_PORT[$id]}"
}

api_request() {
  local method=$1 id=$2 path=$3 payload=${4:-}
  local url
  url="$(api_base_url "$id")$path"
  if [[ "$method" == "GET" ]]; then
    curl --connect-timeout "$API_CONNECT_TIMEOUT" --max-time "$API_MAX_TIME" \
      --silent --show-error --fail "$url" 2>/dev/null || return 1
  else
    curl --connect-timeout "$API_CONNECT_TIMEOUT" --max-time "$API_MAX_TIME" \
      --silent --show-error --fail \
      -H 'Content-Type: application/json' -X "$method" \
      --data-binary "$payload" "$url" 2>/dev/null || return 1
  fi
}

api_get_info() {
  local id=$1
  api_request GET "$id" '/json/info'
}

api_get_state() {
  local id=$1
  api_request GET "$id" '/json/state'
}

api_set_state() {
  local id=$1 payload=$2
  api_request POST "$id" '/json/state' "$payload"
}

api_get_effects() {
  local id=$1
  api_request GET "$id" '/json/effects'
}

api_get_palettes() {
  local id=$1
  api_request GET "$id" '/json/palettes'
}

api_get_presets() {
  local id=$1
  local presets
  presets=$(api_request GET "$id" '/presets.json' || true)
  if [[ -z "$presets" ]]; then
    presets=$(api_request GET "$id" '/json/presets' || true)
  fi
  printf '%s' "$presets"
}

api_probe_wled() {
  local host=$1 port=$2
  local url="http://$host:$port/json/info"
  local info
  info=$(curl --connect-timeout "$API_CONNECT_TIMEOUT" --max-time "$API_MAX_TIME" \
    --silent --show-error --fail "$url" 2>/dev/null || true)
  if [[ -z "$info" ]]; then
    return 1
  fi
  if jq -e 'has("ver") and has("name") and has("leds")' <<<"$info" >/dev/null 2>&1; then
    printf '%s' "$info"
    return 0
  fi
  return 1
}
