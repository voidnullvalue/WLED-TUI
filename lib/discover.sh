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

discover_secondary_verified() {
  local concurrency=${WLEDTUI_DISCOVERY_CONCURRENCY:-8}
  local -a entries=()
  local -a pids=()
  local -a files=()
  local entry name host addr port out pid
  while IFS= read -r entry; do
    [[ -z "$entry" ]] && continue
    entries+=("$entry")
  done < <(discover_secondary)
  for entry in "${entries[@]}"; do
    IFS='|' read -r name host addr port <<<"$entry"
    out=$(mktemp)
    files+=("$out")
    (api_probe_wled "$addr" "$port" >/dev/null 2>&1 && printf '%s\n' "$entry" > "$out") &
    pid=$!
    pids+=("$pid")
    if (( ${#pids[@]} >= concurrency )); then
      wait "${pids[0]}" 2>/dev/null || true
      pids=("${pids[@]:1}")
    fi
  done
  for pid in "${pids[@]}"; do wait "$pid" 2>/dev/null || true; done
  for out in "${files[@]}"; do
    [[ -s "$out" ]] && cat "$out"
    rm -f "$out"
  done
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
      found+=("$entry")
    done < <(discover_secondary_verified)
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

parse_discovery_entry() {
  local entry=$1
  local name host addr port
  IFS='|' read -r name host addr port <<<"$entry"
  if [[ -z "$host" || -z "$port" ]]; then
    return 1
  fi
  if ! is_valid_port "$port"; then
    return 1
  fi
  printf '%s\t%s\t%s\t%s\n' "$name" "$host" "$addr" "$port"
}

discover_devices() {
  local now
  now=$(now_ts)
  local entry parsed name host addr port
  while IFS= read -r entry; do
    [[ -z "$entry" ]] && continue
    parsed=$(parse_discovery_entry "$entry" || true)
    [[ -z "$parsed" ]] && continue
    IFS=$'\t' read -r name host addr port <<<"$parsed"
    # Security: only add devices with validated host/port values.
    local id
    if ! id=$(model_add_device "$name" "$host" "$port" "$addr"); then
      continue
    fi
    DEV_LAST_SEEN[$id]="$now"
  done < <(discover_devices_report)
}
