#!/usr/bin/env bash
set -euo pipefail
shopt -s lastpipe
IFS=$'\n\t'

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/wledtui"
CACHE_FILE="$CONFIG_DIR/devices.json"

log_debug() {
  if [[ -n "${WLEDTUI_DEBUG:-}" ]]; then
    printf '[debug] %s\n' "$*" >&2
  fi
}

now_ts() {
  date +%s
}

ensure_config_dir() {
  mkdir -p "$CONFIG_DIR"
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

read_key() {
  local key
  IFS= read -rsn1 -t 0.1 key || true
  if [[ -z "$key" ]]; then
    printf ''
    return
  fi
  if [[ "$key" == $'\e' ]]; then
    local rest
    IFS= read -rsn2 -t 0.01 rest || rest=''
    key+="$rest"
    if [[ "$rest" == '[' ]]; then
      IFS= read -rsn1 -t 0.01 rest || rest=''
      key+="$rest"
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
