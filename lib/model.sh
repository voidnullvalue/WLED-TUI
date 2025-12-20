#!/usr/bin/env bash
set -euo pipefail
shopt -s lastpipe
IFS=$'\n\t'

source "$(dirname "${BASH_SOURCE[0]}")/util.sh"

declare -a DEVICE_IDS=()
declare -A DEV_NAME=()
declare -A DEV_HOST=()
declare -A DEV_PORT=()
declare -A DEV_ONLINE=()
declare -A DEV_LAST_SEEN=()
declare -A DEV_BRI=()
declare -A DEV_ON=()
declare -A DEV_PRESET=()
declare -A DEV_VER=()
declare -A DEV_WIFI=()
declare -A DEV_UPTIME=()
declare -A DEV_STATE_JSON=()
declare -A DEV_INFO_JSON=()
declare -A DEV_NEXT_POLL=()
declare -A DEV_BACKOFF=()

device_id() {
  local host=$1 port=$2
  printf '%s:%s' "$host" "$port"
}

model_add_device() {
  local name=$1 host=$2 port=$3
  local id
  id=$(device_id "$host" "$port")
  if [[ -z "${DEV_HOST[$id]:-}" ]]; then
    DEVICE_IDS+=("$id")
  fi
  DEV_NAME[$id]="$name"
  DEV_HOST[$id]="$host"
  DEV_PORT[$id]="$port"
  DEV_ONLINE[$id]="0"
  DEV_LAST_SEEN[$id]="0"
  DEV_BRI[$id]="0"
  DEV_ON[$id]="0"
  DEV_PRESET[$id]="0"
  DEV_VER[$id]=""
  DEV_WIFI[$id]=""
  DEV_UPTIME[$id]=""
  DEV_STATE_JSON[$id]=""
  DEV_INFO_JSON[$id]=""
  DEV_NEXT_POLL[$id]="0"
  DEV_BACKOFF[$id]="2"
}

model_remove_device() {
  local id=$1
  local new_ids=()
  for existing in "${DEVICE_IDS[@]}"; do
    if [[ "$existing" != "$id" ]]; then
      new_ids+=("$existing")
    fi
  done
  DEVICE_IDS=("${new_ids[@]}")
  unset DEV_NAME[$id] DEV_HOST[$id] DEV_PORT[$id] DEV_ONLINE[$id] DEV_LAST_SEEN[$id]
  unset DEV_BRI[$id] DEV_ON[$id] DEV_PRESET[$id] DEV_VER[$id] DEV_WIFI[$id]
  unset DEV_UPTIME[$id] DEV_STATE_JSON[$id] DEV_INFO_JSON[$id]
  unset DEV_NEXT_POLL[$id] DEV_BACKOFF[$id]
}

model_load_devices() {
  ensure_config_dir
  if [[ ! -f "$CACHE_FILE" ]]; then
    return
  fi
  jq -c '.devices[]?' "$CACHE_FILE" 2>/dev/null | while IFS= read -r dev; do
    local name host port last_seen id
    name=$(jq -r '.name' <<<"$dev")
    host=$(jq -r '.host' <<<"$dev")
    port=$(jq -r '.port' <<<"$dev")
    last_seen=$(jq -r '.last_seen // 0' <<<"$dev")
    id=$(device_id "$host" "$port")
    model_add_device "$name" "$host" "$port"
    DEV_LAST_SEEN[$id]="$last_seen"
  done
}

model_save_devices() {
  ensure_config_dir
  local json
  json=$(jq -n '{devices: []}')
  for id in "${DEVICE_IDS[@]}"; do
    json=$(jq -c --arg name "${DEV_NAME[$id]}" \
      --arg host "${DEV_HOST[$id]}" \
      --arg port "${DEV_PORT[$id]}" \
      --argjson last_seen "${DEV_LAST_SEEN[$id]}" \
      '.devices += [{name:$name,host:$host,port:($port|tonumber),last_seen:$last_seen}]' <<<"$json")
  done
  printf '%s\n' "$json" > "$CACHE_FILE"
}
