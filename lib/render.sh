#!/usr/bin/env bash
set -euo pipefail
shopt -s lastpipe
IFS=$'\n\t'

RENDER_ROWS=0
RENDER_COLS=0
FULL_REDRAW=1
PREV_LINES=()

RENDER_SGR0=''
RENDER_EL=''
RENDER_CIVIS=''
RENDER_CNORM=''
RENDER_SMCUP=''
RENDER_RMCUP=''

render_init() {
  RENDER_SGR0=$(tput sgr0)
  RENDER_EL=$(tput el)
  RENDER_CIVIS=$(tput civis)
  RENDER_CNORM=$(tput cnorm)
  RENDER_SMCUP=$(tput smcup)
  RENDER_RMCUP=$(tput rmcup)
  printf '%s' "$RENDER_SMCUP"
  printf '%s' "$RENDER_CIVIS"
  render_set_size
}

render_set_size() {
  RENDER_COLS=$(tput cols)
  RENDER_ROWS=$(tput lines)
  FULL_REDRAW=1
  PREV_LINES=()
}

render_draw_frame() {
  local -n frame=$1
  local row
  for ((row=0; row<RENDER_ROWS; row++)); do
    local line="${frame[$row]:-}"
    if (( FULL_REDRAW )) || [[ "${PREV_LINES[$row]:-}" != "$line" ]]; then
      printf '%s' "$(tput cup "$row" 0)"
      printf '%s' "$line"
      printf '%s%s' "$RENDER_SGR0" "$RENDER_EL"
      PREV_LINES[$row]="$line"
    fi
  done
  FULL_REDRAW=0
}

render_shutdown() {
  printf '%s' "$RENDER_SGR0"
  printf '%s' "$RENDER_CNORM"
  printf '%s' "$RENDER_RMCUP"
}
