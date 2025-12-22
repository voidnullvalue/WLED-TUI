#!/usr/bin/env bash
set -euo pipefail
shopt -s lastpipe
IFS=$'\n\t'

source "$(dirname "${BASH_SOURCE[0]}")/util.sh"
source "$(dirname "${BASH_SOURCE[0]}")/api.sh"
source "$(dirname "${BASH_SOURCE[0]}")/model.sh"

discover_parse_avahi() {
  local service=$1
  local line
  local entries=()
  while IFS= read -r line; do
    [[ "$line" =~ ^= ]] || continue
    IFS=';' read -r _ _ _ name _ _ host addr port _ <<<"$line"
    if [[ -n "$host" && -n "$addr" && -n "$port" ]]; then
      entries+=("$name|$host|$addr|$port")
    fi
  done < <(avahi-browse -rtp "$service" 2>/dev/null || true)
  printf '%s\n' "${entries[@]}"
}

discover_primary() {
  if ! is_command avahi-browse; then
    return
  fi
  discover_parse_avahi '_wled._tcp'
}

discover_secondary() {
  if ! is_command avahi-browse; then
    return
  fi
  discover_parse_avahi '_http._tcp'
}

discover_devices_report() {
  local found=()
  local entry name host addr port info

  while IFS= read -r entry; do
    [[ -z "$entry" ]] && continue
    IFS='|' read -r name host addr port <<<"$entry"
    found+=("$name|$host|$addr|$port")
  done < <(discover_primary)

  if [[ ${#found[@]} -eq 0 ]]; then
    while IFS= read -r entry; do
      [[ -z "$entry" ]] && continue
      IFS='|' read -r name host addr port <<<"$entry"
      info=$(api_probe_wled "$addr" "$port" || true)
      if [[ -n "$info" ]]; then
        found+=("$name|$host|$addr|$port")
      fi
    done < <(discover_secondary)
  fi

  for entry in "${found[@]}"; do
    IFS='|' read -r name host addr port <<<"$entry"
    local use_host
    if [[ -n "$host" ]]; then
      use_host="$host"
    else
      use_host="$addr"
    fi
    printf '%s|%s|%s|%s\n' "$name" "$use_host" "$addr" "$port"
  done
}

discover_devices() {
  local now
  now=$(now_ts)
  local entry name host port
  while IFS= read -r entry; do
    [[ -z "$entry" ]] && continue
    IFS='|' read -r name host port <<<"$entry"
    # Security: only add devices with validated host/port values.
    if ! model_add_device "$name" "$host" "$port"; then
      continue
    fi
    local id
    id=$(device_id "$host" "$port")
    DEV_LAST_SEEN[$id]="$now"
  done < <(discover_devices_report)
}
