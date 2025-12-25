#!/usr/bin/env bash
set -euo pipefail
shopt -s lastpipe
IFS=$'\n\t'

source "$(dirname "${BASH_SOURCE[0]}")/util.sh"

declare -a DEVICE_IDS=()
declare -A DEV_NAME=()
declare -A DEV_ALIAS=()
declare -A DEV_WLED_NAME=()
declare -A DEV_INFO_TS=()
declare -A DEV_HOST=()
declare -A DEV_PORT=()
declare -A DEV_IP=()
declare -A DEV_ONLINE=()
declare -A DEV_LAST_SEEN=()
declare -A DEV_BRI=()
declare -A DEV_UI_BRI=()
declare -A DEV_DESIRED_BRI=()
declare -A DEV_DESIRED_ON=()
declare -A DEV_DESIRED_PRESET=()
declare -A DEV_DESIRED_TRANSITION=()
declare -A DEV_DESIRED_NL_ON=()
declare -A DEV_DESIRED_LIVE=()
declare -A DEV_PENDING_PATCH=()
declare -A DEV_PATCH_DUE_MS=()
declare -A DEV_PATCH_INFLIGHT_PID=()
declare -A DEV_PATCH_LAST_SEND_MS=()
declare -A DEV_LAST_USER_ACTION_MS=()
declare -A DEV_GET_STATE_INFLIGHT_PID=()
declare -A DEV_GET_INFO_INFLIGHT_PID=()
declare -A DEV_GET_PRESETS_INFLIGHT_PID=()
declare -A DEV_GET_EFFECTS_INFLIGHT_PID=()
declare -A DEV_GET_PALETTES_INFLIGHT_PID=()
declare -A DEV_ON=()
declare -A DEV_PRESET=()
declare -A DEV_VER=()
declare -A DEV_WIFI=()
declare -A DEV_UPTIME=()
declare -A DEV_STATE_JSON=()
declare -A DEV_INFO_JSON=()
declare -A DEV_NEXT_POLL=()
declare -A DEV_BACKOFF=()
declare -A DEV_TRANSITION=()
declare -A DEV_NL_ON=()
declare -A DEV_NL_DUR=()
declare -A DEV_LIVE=()
declare -A DEV_PRESETS_JSON=()
declare -A DEV_PRESETS_CYCLE=()
declare -A DEV_EFFECTS_JSON=()
declare -A DEV_EFFECTS_PARSE_ERROR=()
declare -A DEV_EFFECTS_TS=()
declare -A DEV_PALETTES_JSON=()
declare -A DEV_STATE_TS=()
declare -A DEV_STATE_STALE=()

device_id() {
  local host=$1 port=$2
  printf '%s:%s' "$host" "$port"
}

model_add_device() {
  local name=$1 host=$2 port=$3 ip=${4:-}
  local id
  # Security: reject unsafe host/port values from user, cache, or network discovery.
  if ! is_valid_host "$host" || ! is_valid_port "$port"; then
    log_debug "Rejected device with unsafe host/port host=${host} port=${port}"
    return 1
  fi
  id=$(device_id "$host" "$port")
  local existing_alias=${DEV_ALIAS[$id]:-}
  local existing_wled=${DEV_WLED_NAME[$id]:-}
  local existing_name=${DEV_NAME[$id]:-}
  local existing_info_ts=${DEV_INFO_TS[$id]:-0}
  local existing_ip=${DEV_IP[$id]:-}
  if [[ -z "${DEV_HOST[$id]:-}" ]]; then
    DEVICE_IDS+=("$id")
  fi
  if [[ -n "$name" ]]; then
    DEV_NAME[$id]="$name"
  else
    DEV_NAME[$id]="$existing_name"
  fi
  DEV_ALIAS[$id]="$existing_alias"
  DEV_WLED_NAME[$id]="$existing_wled"
  DEV_HOST[$id]="$host"
  DEV_PORT[$id]="$port"
  if [[ -n "$ip" ]]; then
    DEV_IP[$id]="$ip"
  else
    DEV_IP[$id]="$existing_ip"
  fi
  DEV_ONLINE[$id]="0"
  DEV_LAST_SEEN[$id]="0"
  DEV_BRI[$id]="0"
  DEV_UI_BRI[$id]="0"
  DEV_DESIRED_BRI[$id]=""
  DEV_DESIRED_ON[$id]=""
  DEV_DESIRED_PRESET[$id]=""
  DEV_DESIRED_TRANSITION[$id]=""
  DEV_DESIRED_NL_ON[$id]=""
  DEV_DESIRED_LIVE[$id]=""
  DEV_PENDING_PATCH[$id]=""
  DEV_PATCH_DUE_MS[$id]="0"
  DEV_PATCH_INFLIGHT_PID[$id]=""
  DEV_PATCH_LAST_SEND_MS[$id]="0"
  DEV_LAST_USER_ACTION_MS[$id]="0"
  DEV_GET_STATE_INFLIGHT_PID[$id]=""
  DEV_GET_INFO_INFLIGHT_PID[$id]=""
  DEV_GET_PRESETS_INFLIGHT_PID[$id]=""
  DEV_GET_EFFECTS_INFLIGHT_PID[$id]=""
  DEV_GET_PALETTES_INFLIGHT_PID[$id]=""
  DEV_ON[$id]="0"
  DEV_PRESET[$id]="0"
  DEV_VER[$id]=""
  DEV_WIFI[$id]=""
  DEV_UPTIME[$id]=""
  DEV_STATE_JSON[$id]=""
  DEV_INFO_JSON[$id]=""
  DEV_NEXT_POLL[$id]="0"
  DEV_BACKOFF[$id]="2"
  DEV_INFO_TS[$id]="$existing_info_ts"
  DEV_TRANSITION[$id]="0"
  DEV_NL_ON[$id]="false"
  DEV_NL_DUR[$id]="0"
  DEV_LIVE[$id]="false"
  DEV_PRESETS_JSON[$id]=""
  DEV_PRESETS_CYCLE[$id]="0"
  DEV_EFFECTS_JSON[$id]=""
  DEV_EFFECTS_PARSE_ERROR[$id]=""
  DEV_EFFECTS_TS[$id]="0"
  DEV_PALETTES_JSON[$id]=""
  DEV_STATE_TS[$id]="0"
  DEV_STATE_STALE[$id]="0"
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
  unset DEV_NAME[$id] DEV_ALIAS[$id] DEV_WLED_NAME[$id] DEV_HOST[$id] DEV_PORT[$id] DEV_ONLINE[$id] DEV_LAST_SEEN[$id]
  unset DEV_IP[$id]
  unset DEV_BRI[$id] DEV_UI_BRI[$id] DEV_DESIRED_BRI[$id] DEV_DESIRED_ON[$id] DEV_DESIRED_PRESET[$id]
  unset DEV_DESIRED_TRANSITION[$id] DEV_DESIRED_NL_ON[$id] DEV_DESIRED_LIVE[$id]
  unset DEV_PENDING_PATCH[$id] DEV_PATCH_DUE_MS[$id] DEV_PATCH_INFLIGHT_PID[$id] DEV_PATCH_LAST_SEND_MS[$id]
  unset DEV_LAST_USER_ACTION_MS[$id]
  unset DEV_GET_STATE_INFLIGHT_PID[$id] DEV_GET_INFO_INFLIGHT_PID[$id]
  unset DEV_GET_PRESETS_INFLIGHT_PID[$id] DEV_GET_EFFECTS_INFLIGHT_PID[$id] DEV_GET_PALETTES_INFLIGHT_PID[$id]
  unset DEV_ON[$id] DEV_PRESET[$id] DEV_VER[$id] DEV_WIFI[$id]
  unset DEV_UPTIME[$id] DEV_STATE_JSON[$id] DEV_INFO_JSON[$id] DEV_INFO_TS[$id]
  unset DEV_NEXT_POLL[$id] DEV_BACKOFF[$id]
  unset DEV_TRANSITION[$id] DEV_NL_ON[$id] DEV_NL_DUR[$id] DEV_LIVE[$id]
  unset DEV_PRESETS_JSON[$id] DEV_EFFECTS_JSON[$id] DEV_PALETTES_JSON[$id]
  unset DEV_PRESETS_CYCLE[$id]
  unset DEV_EFFECTS_PARSE_ERROR[$id] DEV_EFFECTS_TS[$id]
  unset DEV_STATE_TS[$id] DEV_STATE_STALE[$id]
}

device_display_name() {
  local id=$1
  local alias=${DEV_ALIAS[$id]:-}
  local wled=${DEV_WLED_NAME[$id]:-}
  local mdns=${DEV_NAME[$id]:-}
  if [[ -n "$alias" ]]; then
    printf '%s' "$alias"
    return
  fi
  if [[ -n "$wled" ]]; then
    printf '%s' "$wled"
    return
  fi
  if [[ -n "$mdns" ]]; then
    printf '%s' "$mdns"
    return
  fi
  printf '%s:%s' "${DEV_HOST[$id]}" "${DEV_PORT[$id]}"
}

model_load_devices() {
  ensure_cache_dir
  if [[ ! -f "$CACHE_FILE" ]]; then
    return
  fi
  jq -c '.devices[]?' "$CACHE_FILE" 2>/dev/null | while IFS= read -r dev; do
    local name host port ip last_seen id alias wled_name state state_ts
    name=$(jq -r '.mdns_name // .name // ""' <<<"$dev")
    alias=$(jq -r '.alias // ""' <<<"$dev")
    wled_name=$(jq -r '.wled_name // ""' <<<"$dev")
    host=$(jq -r '.host' <<<"$dev")
    ip=$(jq -r '.ip // ""' <<<"$dev")
    port=$(jq -r '.port' <<<"$dev")
    # Security: skip cached entries with unsafe host/port values.
    if ! is_valid_host "$host" || ! is_valid_port "$port"; then
      log_debug "Skipping cached device with unsafe host/port host=${host} port=${port}"
      continue
    fi
    last_seen=$(jq -r '.last_seen // 0' <<<"$dev")
    state=$(jq -c '.state // empty' <<<"$dev" 2>/dev/null || true)
    state_ts=$(jq -r '.state_ts // 0' <<<"$dev" 2>/dev/null || printf '0')
    id=$(device_id "$host" "$port")
    # Security: ensure only validated devices are loaded into memory.
    if ! model_add_device "$name" "$host" "$port" "$ip"; then
      continue
    fi
    DEV_ALIAS[$id]="$alias"
    DEV_WLED_NAME[$id]="$wled_name"
    DEV_LAST_SEEN[$id]="$last_seen"
    DEV_STATE_TS[$id]="$state_ts"
    if [[ -n "$state" ]] && jq -e '.' <<<"$state" >/dev/null 2>&1; then
      DEV_STATE_JSON[$id]="$state"
      DEV_BRI[$id]=$(jq -r '.bri // 0' <<<"$state")
      DEV_ON[$id]=$(jq -r '.on // false' <<<"$state")
      DEV_PRESET[$id]=$(jq -r '.ps // 0' <<<"$state")
      DEV_TRANSITION[$id]=$(jq -r '.transition // 0' <<<"$state")
      DEV_NL_ON[$id]=$(jq -r '.nl.on // false' <<<"$state")
      DEV_NL_DUR[$id]=$(jq -r '.nl.dur // 0' <<<"$state")
      DEV_LIVE[$id]=$(jq -r '.live // false' <<<"$state")
      DEV_STATE_STALE[$id]="1"
    fi
  done
}

model_save_devices() {
  ensure_cache_dir
  local json
  json=$(jq -n '{devices: []}')
  for id in "${DEVICE_IDS[@]}"; do
    local state_json="${DEV_STATE_JSON[$id]:-}"
    local state_ts="${DEV_STATE_TS[$id]:-0}"
    if [[ -n "$state_json" ]] && jq -e '.' <<<"$state_json" >/dev/null 2>&1; then
      json=$(jq -c --arg name "${DEV_NAME[$id]}" \
        --arg alias "${DEV_ALIAS[$id]:-}" \
        --arg wled_name "${DEV_WLED_NAME[$id]:-}" \
        --arg host "${DEV_HOST[$id]}" \
        --arg ip "${DEV_IP[$id]:-}" \
        --arg port "${DEV_PORT[$id]}" \
        --argjson last_seen "${DEV_LAST_SEEN[$id]}" \
        --argjson state "$state_json" \
        --argjson state_ts "$state_ts" \
        '.devices += [{name:$name,mdns_name:$name,alias:$alias,wled_name:$wled_name,host:$host,ip:$ip,port:($port|tonumber),last_seen:$last_seen,state:$state,state_ts:$state_ts}]' <<<"$json")
    else
      json=$(jq -c --arg name "${DEV_NAME[$id]}" \
        --arg alias "${DEV_ALIAS[$id]:-}" \
        --arg wled_name "${DEV_WLED_NAME[$id]:-}" \
        --arg host "${DEV_HOST[$id]}" \
        --arg ip "${DEV_IP[$id]:-}" \
        --arg port "${DEV_PORT[$id]}" \
        --argjson last_seen "${DEV_LAST_SEEN[$id]}" \
        --argjson state_ts "$state_ts" \
        '.devices += [{name:$name,mdns_name:$name,alias:$alias,wled_name:$wled_name,host:$host,ip:$ip,port:($port|tonumber),last_seen:$last_seen,state:null,state_ts:$state_ts}]' <<<"$json")
    fi
  done
  # Security: write cache without invoking a shell.
  with_lock "$CACHE_LOCK" write_file "$json" "$CACHE_FILE"
}
