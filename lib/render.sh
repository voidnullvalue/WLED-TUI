#!/usr/bin/env bash
set -euo pipefail
shopt -s lastpipe
IFS=$'\n\t'

RENDER_ROWS=0
RENDER_COLS=0
FULL_REDRAW=1
PREV_LINES=()
declare -A DIRTY_ROWS=()

RENDER_SGR0=''
RENDER_EL=''
RENDER_CIVIS=''
RENDER_CNORM=''
RENDER_SMCUP=''
RENDER_RMCUP=''

render_init() {
  RENDER_SGR0=$'\e[0m'
  RENDER_EL=$'\e[K'
  RENDER_CIVIS=$'\e[?25l'
  RENDER_CNORM=$'\e[?25h'
  RENDER_SMCUP=$'\e[?1049h'
  RENDER_RMCUP=$'\e[?1049l'
  printf '%s' "$RENDER_SMCUP"
  printf '%s' "$RENDER_CIVIS"
  render_set_size
}

render_set_size() {
  RENDER_COLS=$(tput cols)
  RENDER_ROWS=$(tput lines)
  FULL_REDRAW=1
  PREV_LINES=()
  DIRTY_ROWS=()
}

render_cup() {
  local row=$1 col=$2
  printf '\e[%d;%dH' $((row+1)) $((col+1))
}

render_mark_dirty() {
  local row=$1
  DIRTY_ROWS[$row]=1
}

render_has_dirty() {
  if (( ${#DIRTY_ROWS[@]} > 0 )); then
    return 0
  fi
  return 1
}

render_clear_dirty() {
  DIRTY_ROWS=()
}

render_draw_frame() {
  local -n frame=$1
  local row
  for ((row=0; row<RENDER_ROWS; row++)); do
    local line="${frame[$row]:-}"
    if (( FULL_REDRAW )) || [[ "${PREV_LINES[$row]:-}" != "$line" ]]; then
      render_cup "$row" 0
      printf '%s' "$line"
      printf '%s%s' "$RENDER_SGR0" "$RENDER_EL"
      PREV_LINES[$row]="$line"
    fi
  done
  FULL_REDRAW=0
  render_clear_dirty
}

render_flush_dirty() {
  local -n frame=$1
  if (( FULL_REDRAW )); then
    render_draw_frame frame
    return
  fi
  local row
  for row in "${!DIRTY_ROWS[@]}"; do
    local line="${frame[$row]:-}"
    if [[ "${PREV_LINES[$row]:-}" != "$line" ]]; then
      render_cup "$row" 0
      printf '%s' "$line"
      printf '%s%s' "$RENDER_SGR0" "$RENDER_EL"
      PREV_LINES[$row]="$line"
    fi
  done
  render_clear_dirty
}

render_shutdown() {
  printf '%s' "$RENDER_SGR0"
  printf '%s' "$RENDER_CNORM"
  printf '%s' "$RENDER_RMCUP"
}
