#!/usr/bin/env bash
set -euo pipefail
shopt -s lastpipe
IFS=$'\n\t'

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/wledtui"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/wledtui"
CONFIG_FILE="$CONFIG_DIR/devices.json"
CACHE_FILE="$CACHE_DIR/devices.json"
CACHE_LOCK="$CACHE_DIR/devices.lock"
DEBUG_LOG_FILE="$CACHE_DIR/debug.log"

log_debug() {
  if [[ "${WLEDTUI_DEBUG:-}" == "1" ]]; then
    ensure_cache_dir
    printf '%s %s\n' "$(date -Iseconds)" "$*" >> "$DEBUG_LOG_FILE"
  fi
}

strip_ansi() {
  # Security: strip ANSI escape sequences so untrusted text cannot emit terminal control codes.
  printf '%s' "$1" | sed -E 's/\x1B\[[0-9;?]*[ -/]*[@-~]//g; s/\x1B\][^\a]*\a//g; s/\x1B[@-Z\\-_]//g'
}

sanitize_for_display() {
  # Security: remove control characters and ANSI escapes to prevent terminal injection.
  local text
  text=$(strip_ansi "$1")
  text=$(printf '%s' "$text" | tr -d '\000-\010\013\014\016-\037\177')
  text=${text//$'\n'/ }
  text=${text//$'\t'/ }
  printf '%s' "$text"
}

is_valid_host() {
  local host=$1
  # Security: allow only hostname/IP-safe characters to prevent URL/argument injection.
  [[ -n "$host" && "$host" =~ ^[A-Za-z0-9._-]+$ ]]
}

is_valid_port() {
  local port=$1
  # Security: require numeric TCP port ranges to prevent URL/argument injection.
  [[ "$port" =~ ^[0-9]{1,5}$ ]] && (( port >= 1 && port <= 65535 ))
}

write_file() {
  # Security: avoid shell evaluation when writing cached JSON.
  local content=$1 path=$2
  printf '%s\n' "$content" > "$path"
}

now_ts() {
  date +%s
}

now_ms() {
  date +%s%3N
}

sleep_ms() {
  local ms=$1
  if [[ -z "$ms" || "$ms" == "0" ]]; then
    return
  fi
  local seconds
  seconds=$(awk -v ms="$ms" 'BEGIN {printf "%.3f", ms/1000}')
  sleep "$seconds"
}

ensure_config_dir() {
  mkdir -p "$CONFIG_DIR"
}

ensure_cache_dir() {
  mkdir -p "$CACHE_DIR"
}
clamp() {
  local value=$1 min=$2 max=$3
  if (( value < min )); then
    printf '%s' "$min"
  elif (( value > max )); then
    printf '%s' "$max"
  else
    printf '%s' "$value"
  fi
}

json_safe() {
  jq -c '.' 2>/dev/null
}

is_command() {
  command -v "$1" >/dev/null 2>&1
}

color_support() {
  if [[ -n "${NO_COLOR:-}" ]]; then
    echo 0
    return
  fi
  if ! tput colors >/dev/null 2>&1; then
    echo 0
    return
  fi
  if (( $(tput colors) >= 8 )); then
    echo 1
  else
    echo 0
  fi
}

set_term_title() {
  # Security: sanitize title to prevent terminal control injection.
  printf '\033]0;%s\007' "$(sanitize_for_display "$1")"
}

with_lock() {
  local lockfile=$1
  shift
  local lock_fd
  exec {lock_fd}>"$lockfile"
  flock -x "$lock_fd"
  "$@"
  local status=$?
  flock -u "$lock_fd"
  exec {lock_fd}>&-
  return "$status"
}

parse_presets_tsv() {
  jq -r '
    if type == "object" then
      to_entries
      | map(select(.value != null))
      | map({id:(.key|tostring), sort:(.key|tonumber? // 9999999999), name:(.value.n // ("Preset " + .key))})
      | sort_by(.sort, .id)
      | .[]
      | "\(.id)\t\(.name)"
    elif type == "array" then
      to_entries
      | map(select(.value != null))
      | map({id:(.key|tostring), name:(.value|tostring)})
      | .[]
      | "\(.id)\t\(.name)"
    else empty end
  '
}

read_key() {
  local key
  if IFS= read -rsn1 -t 0.05 key; then
    local status=0
  else
    local status=$?
  fi
  if (( status != 0 )); then
    printf '__NONE__'
    return
  fi
  if [[ "$key" == $'\e' ]]; then
    local rest
    IFS= read -rsn1 -t 0.01 rest || rest=''
    if [[ -z "$rest" ]]; then
      printf '%s' "$key"
      return
    fi
    key+="$rest"
    if [[ "$rest" == '[' || "$rest" == 'O' ]]; then
      while IFS= read -rsn1 -t 0.01 rest; do
        key+="$rest"
        if [[ "$rest" =~ [A-Za-z~] ]]; then
          break
        fi
      done
    fi
  fi
  printf '%s' "$key"
}

prompt_input() {
  local prompt=$1
  local input
  tput cnorm
  stty echo
  # Security: sanitize prompts to keep untrusted labels inert.
  printf '%s' "$(sanitize_for_display "$prompt")"
  IFS= read -r input
  stty -echo
  tput civis
  printf '%s' "$input"
}

confirm_prompt() {
  local prompt=$1
  local reply
  tput cnorm
  stty echo
  # Security: sanitize prompts to keep untrusted labels inert.
  printf '%s [y/N]: ' "$(sanitize_for_display "$prompt")"
  IFS= read -r reply
  stty -echo
  tput civis
  [[ "$reply" =~ ^[Yy]$ ]]
}
