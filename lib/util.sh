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
  printf '\033]0;%s\007' "$1"
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
      | map({id:(.key|tonumber?), name:(.value.n // ("Preset " + .key))})
      | map(select(.id != null))
      | sort_by(.id)
      | .[]
      | "\(.id)\t\(.name)"
    elif type == "array" then
      to_entries
      | map(select(.value != null))
      | map({id:(.key|tonumber), name:(.value|tostring)})
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
  printf '%s' "$prompt"
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
  printf '%s [y/N]: ' "$prompt"
  IFS= read -r reply
  stty -echo
  tput civis
  [[ "$reply" =~ ^[Yy]$ ]]
}
