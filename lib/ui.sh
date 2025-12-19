#!/usr/bin/env bash
set -euo pipefail
shopt -s lastpipe
IFS=$'\n\t'

source "$(dirname "${BASH_SOURCE[0]}")/util.sh"

UI_COLOR=0

ui_init() {
  UI_COLOR=$(color_support)
  tput smcup
  tput civis
  stty -echo
  trap 'ui_restore' EXIT INT TERM
}

ui_restore() {
  stty echo
  tput cnorm
  tput rmcup
}

ui_clear() {
  tput clear
}

ui_draw_topbar() {
  local cols=$1
  local title=$2
  local status=$3
  tput cup 0 0
  if (( UI_COLOR )); then
    tput setaf 0; tput setab 6
  fi
  printf '%-*s' "$cols" " $title $status"
  if (( UI_COLOR )); then
    tput sgr0
  fi
}

ui_draw_box() {
  local row=$1 col=$2 height=$3 width=$4 title=$5
  tput cup "$row" "$col"
  printf '+%s+' "$(printf '%*s' $((width-2)) | tr ' ' '-')"
  local i
  for ((i=1;i<height-1;i++)); do
    tput cup $((row+i)) "$col"
    printf '|%*s|' $((width-2)) ''
  done
  tput cup $((row+height-1)) "$col"
  printf '+%s+' "$(printf '%*s' $((width-2)) | tr ' ' '-')"
  if [[ -n "$title" ]]; then
    tput cup "$row" $((col+2))
    printf '%s' "$title"
  fi
}

ui_draw_list_item() {
  local row=$1 col=$2 width=$3 text=$4 selected=$5 dimmed=$6
  tput cup "$row" "$col"
  if (( selected )); then
    if (( UI_COLOR )); then
      tput setaf 0; tput setab 2
    else
      tput smso
    fi
  elif (( dimmed )); then
    tput dim
  fi
  printf '%-*s' "$width" "$text"
  tput sgr0
}

ui_draw_help_overlay() {
  local rows cols
  rows=$(tput lines)
  cols=$(tput cols)
  local width=$((cols-4))
  local lines=(
    "q: quit"
    "Tab/Shift-Tab: next/prev tab"
    "Up/Down: navigate"
    "Left/Right: adjust"
    "Enter: select/apply"
    "r: refresh now"
    "a: add device"
    "d: delete device"
    "e: edit device"
    "s: discovery scan"
    "[/]: prev/next device"
    "i: toggle speed/intensity"
    "c: toggle RGB channel"
    "g: apply to all segments"
    "l: toggle live mode"
    "b: reboot selected device"
    "?: toggle help"
  )
  local height=$(( ${#lines[@]} + 4 ))
  local row=$(( (rows-height)/2 ))
  local col=2
  ui_draw_box "$row" "$col" "$height" "$width" " Help "
  local i
  for i in "${!lines[@]}"; do
    tput cup $((row+2+i)) $((col+2))
    printf '%s' "${lines[$i]}"
  done
}
