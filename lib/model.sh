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
MODEL_DIRTY_FLAG=0
MODEL_LAST_SAVE_MS=0
MODEL_SAVE_DEBOUNCE_MS=${WLEDTUI_MODEL_SAVE_DEBOUNCE_MS:-2000}

model_mark_dirty() { MODEL_DIRTY_FLAG=1; }

model_maybe_save() {
  local now=${1:-$(now_ms)}
  (( MODEL_DIRTY_FLAG )) || return
  if (( now - MODEL_LAST_SAVE_MS < MODEL_SAVE_DEBOUNCE_MS )); then
    return
  fi
  model_save_devices
}

device_id() {
  local host=$1 port=$2
  printf '%s:%s' "$host" "$port"
}

model_find_existing_device() {
  local name=$1 host=$2 addr=${3:-} port=$4
  local id

  # 1) Same host:port
  id=$(device_id "$host" "$port")
  if [[ -n "${DEV_HOST[$id]:-}" ]]; then
    printf '%s' "$id"
    return
  fi

  # 2) Same stored ip:port
  if [[ -n "$addr" ]]; then
    for id in "${DEVICE_IDS[@]}"; do
      [[ "${DEV_PORT[$id]:-}" == "$port" ]] || continue
      [[ "${DEV_IP[$id]:-}" == "$addr" ]] || continue
      printf '%s' "$id"
      return
    done
  fi

  # 3) Same WLED name + port
  if [[ -n "$name" ]]; then
    for id in "${DEVICE_IDS[@]}"; do
      [[ "${DEV_PORT[$id]:-}" == "$port" ]] || continue
      [[ "${DEV_WLED_NAME[$id]:-}" == "$name" ]] || continue
      printf '%s' "$id"
      return
    done
  fi

  # 4) Same mDNS/service name + port
  if [[ -n "$name" ]]; then
    for id in "${DEVICE_IDS[@]}"; do
      [[ "${DEV_PORT[$id]:-}" == "$port" ]] || continue
      [[ "${DEV_NAME[$id]:-}" == "$name" ]] || continue
      printf '%s' "$id"
      return
    done
  fi
}

model_add_device() {
  local name=$1 host=$2 port=$3 ip=${4:-}
  local id existing_id
  # Security: reject unsafe host/port values from user, cache, or network discovery.
  if ! is_valid_host "$host" || ! is_valid_port "$port"; then
    log_debug "Rejected device with unsafe host/port host=${host} port=${port}"
    return 1
  fi
  existing_id=$(model_find_existing_device "$name" "$host" "$ip" "$port")
  if [[ -n "$existing_id" ]]; then
    id="$existing_id"
  else
    id=$(device_id "$host" "$port")
  fi
  local existing_alias=${DEV_ALIAS[$id]:-}
  local existing_wled=${DEV_WLED_NAME[$id]:-}
  local existing_name=${DEV_NAME[$id]:-}
  local existing_info_ts=${DEV_INFO_TS[$id]:-0}
  local existing_ip=${DEV_IP[$id]:-}
  if [[ -z "${DEV_HOST[$id]:-}" ]]; then
    DEVICE_IDS+=("$id")
  fi
  if [[ -n "$name" && -z "$existing_wled" ]]; then
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
  DEV_ON[$id]="false"
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
  jq -rc '.devices[]? | [(.mdns_name // .name // ""),(.alias // ""),(.wled_name // ""),.host,(.ip // ""),(.port|tostring),(.last_seen // 0|tostring),(.state_ts // 0|tostring),(.state // null | @json)] | @tsv' "$CACHE_FILE" 2>/dev/null | while IFS=$'\t' read -r name alias wled_name host ip port last_seen state_ts state; do
    local id
    # Security: skip cached entries with unsafe host/port values.
    if ! is_valid_host "$host" || ! is_valid_port "$port"; then
      log_debug "Skipping cached device with unsafe host/port host=${host} port=${port}"
      continue
    fi
    id=$(device_id "$host" "$port")
    # Security: ensure only validated devices are loaded into memory.
    if ! model_add_device "$name" "$host" "$port" "$ip"; then
      continue
    fi
    DEV_ALIAS[$id]="$alias"
    DEV_WLED_NAME[$id]="$wled_name"
    DEV_LAST_SEEN[$id]="$last_seen"
    DEV_STATE_TS[$id]="$state_ts"
    if [[ "$state" != "null" ]] && jq -e '.' <<<"$state" >/dev/null 2>&1; then
      DEV_STATE_JSON[$id]="$state"
      DEV_BRI[$id]=$(jq -r '.bri // 0' <<<"$state")
      DEV_ON[$id]=$(jq -r '.on // false' <<<"$state")
      DEV_PRESET[$id]=$(jq -r '.ps // 0' <<<"$state")
      DEV_TRANSITION[$id]=$(jq -r '.transition // 0' <<<"$state")
      DEV_NL_ON[$id]=$(jq -r '.nl.on // false' <<<"$state")
      DEV_NL_DUR[$id]=$(jq -r '.nl.dur // 0' <<<"$state")
      DEV_STATE_STALE[$id]="1"
    fi
  done
}

model_save_devices() {
  ensure_cache_dir
  local rows=() id state_json state_ts
  for id in "${DEVICE_IDS[@]}"; do
    state_json="${DEV_STATE_JSON[$id]:-null}"
    state_ts="${DEV_STATE_TS[$id]:-0}"
    rows+=("$(printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s' "${DEV_NAME[$id]}" "${DEV_ALIAS[$id]:-}" "${DEV_WLED_NAME[$id]:-}" "${DEV_HOST[$id]}" "${DEV_IP[$id]:-}" "${DEV_PORT[$id]}" "${DEV_LAST_SEEN[$id]:-0}" "$state_ts" "$state_json")")
  done
  local json='{"devices":[]}'
  if (( ${#rows[@]} > 0 )); then
    json=$(printf '%s\n' "${rows[@]}" | jq -Rsc 'split("\n")|map(select(length>0)|split("\t"))|{devices: map({name:.[0],mdns_name:.[0],alias:.[1],wled_name:.[2],host:.[3],ip:.[4],port:(.[5]|tonumber),last_seen:(.[6]|tonumber),state_ts:(.[7]|tonumber),state:(.[8]|fromjson?)})}')
  fi
  # Security: write cache without invoking a shell.
  with_lock "$CACHE_LOCK" write_file "$json" "$CACHE_FILE"
  MODEL_DIRTY_FLAG=0
  MODEL_LAST_SAVE_MS=$(now_ms)
}
