#!/usr/bin/env bash
set -euo pipefail
shopt -s lastpipe
IFS=$'\n\t'

source "$(dirname "${BASH_SOURCE[0]}")/util.sh"
source "$(dirname "${BASH_SOURCE[0]}")/render.sh"

UI_COLOR=0
UI_SGR0=''
UI_DIM_ON=''
UI_SEL_ON=''
UI_TOPBAR_ON=''

ui_init() {
  UI_COLOR=$(color_support)
  UI_SGR0=$(tput sgr0)
  UI_DIM_ON=$(tput dim)
  if (( UI_COLOR )); then
    UI_SEL_ON="$(tput setaf 0)$(tput setab 2)"
    UI_TOPBAR_ON="$(tput setaf 0)$(tput setab 6)"
  else
    UI_SEL_ON=$(tput smso)
  fi
  render_init
  stty -echo
  trap 'ui_restore' EXIT INT TERM
}

ui_restore() {
  stty echo
  render_shutdown
}

ui_clear() {
  tput clear
}

ui_trim_text() {
  local text=$1 width=$2
  if (( ${#text} > width )); then
    text=${text:0:width}
  fi
  printf '%s' "$text"
}

ui_pad_text() {
  local text=$1 width=$2
  text=$(ui_trim_text "$text" "$width")
  printf '%-*s' "$width" "$text"
}

ui_format_topbar() {
  local cols=$1
  local title=$2
  local status=$3
  local text=" $title $status"
  text=$(ui_trim_text "$text" "$cols")
  local pad=$((cols-${#text}))
  local padded="${text}$(printf '%*s' "$pad")"
  if (( UI_COLOR )); then
    printf '%s%s%s' "$UI_TOPBAR_ON" "$padded" "$UI_SGR0"
  else
    printf '%s' "$padded"
  fi
}

ui_format_footer() {
  local cols=$1
  local text=$2
  local padded
  text=$(ui_trim_text " $text" "$cols")
  local pad=$((cols-${#text}))
  padded="${text}$(printf '%*s' "$pad")"
  if (( UI_COLOR )); then
    printf '%s%s%s' "$UI_DIM_ON" "$padded" "$UI_SGR0"
  else
    printf '%s' "$padded"
  fi
}

ui_format_list_item() {
  local text=$1 width=$2 selected=$3 dimmed=$4
  text=$(ui_trim_text "$text" "$width")
  local pad=$((width-${#text}))
  local padded="${text}$(printf '%*s' "$pad")"
  if (( selected )); then
    printf '%s%s%s' "$UI_SEL_ON" "$padded" "$UI_SGR0"
  elif (( dimmed )); then
    printf '%s%s%s' "$UI_DIM_ON" "$padded" "$UI_SGR0"
  else
    printf '%s' "$padded"
  fi
}
