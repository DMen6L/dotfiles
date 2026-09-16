#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Screenshot

# Import Current Theme
source "$HOME"/.config/rofi/shared/theme.bash
theme="$type/$style"

# Theme Elements
prompt='Screenshot'
mesg="DIR: $(xdg-user-dir PICTURES)/Screenshots"

list_col='5'
list_row='1'
win_width='700px'

# if [[ "$theme" == *'type-1'* ]]; then
#   list_col='1'
#   list_row='5'
#   win_width='400px'
# elif [[ "$theme" == *'type-3'* ]]; then
#   list_col='1'
#   list_row='5'
#   win_width='120px'
# elif [[ "$theme" == *'type-5'* ]]; then
#   list_col='1'
#   list_row='5'
#   win_width='520px'
# elif [[ ("$theme" == *'type-2'*) || ("$theme" == *'type-4'*) ]]; then
#   list_col='5'
#   list_row='1'
#   win_width='670px'
# fi

# Options

option_1="󰹑"
option_2="󰆞"
option_3="󰖲"
option_4="󱑂 5"
option_5="󰥔 10"
# layout=$(cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2)
# if [[ "$layout" == 'NO' ]]; then
#   option_1=" Capture Desktop"
#   option_2=" Capture Area"
#   option_3=" Capture Window"
#   option_4=" Capture in 5s"
#   option_5=" Capture in 10s"
# else
#   option_1=""
#   option_2=""
#   option_3=""
#   option_4=""
#   option_5=""
# fi

# Rofi CMD
rofi_cmd() {
  rofi -theme-str "window {width: $win_width;}" \
    -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    -markup-rows \
    -theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
  echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Screenshot
time=$(date +%Y-%m-%d-%H-%M-%S)
file="Screenshot_${time}.png"
dir="$(xdg-user-dir PICTURES)/Screenshots"

if [[ ! -d "$dir" ]]; then
  mkdir -p "$dir"
fi

# notify and view screenshot
notify_view() {
  notify-send \
    "Screenshot saved" \
    "$dir/$file"
}

# countdown
countdown() {
  for sec in $(seq $1 -1 1); do
    notify-send "Taking screenshot in $sec..."
    sleep 1
  done
}

# take shots
shotnow() {
  grimblast copysave screen "$dir/$file"
  notify_view
}

shot5() {
  countdown 5
  grimblast copysave screen "$dir/$file"
  notify_view
}

shot10() {
  countdown 10
  grimblast copysave screen "$dir/$file"
  notify_view
}

shotwin() {
  grimblast copysave active "$dir/$file"
  notify_view
}

shotarea() {
  grimblast copysave area "$dir/$file"
  notify_view
}

# Execute Command
run_cmd() {
  if [[ "$1" == '--opt1' ]]; then
    shotnow
  elif [[ "$1" == '--opt2' ]]; then
    shotarea
  elif [[ "$1" == '--opt3' ]]; then
    shotwin
  elif [[ "$1" == '--opt4' ]]; then
    shot5
  elif [[ "$1" == '--opt5' ]]; then
    shot10
  fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
$option_1)
  run_cmd --opt1
  ;;
$option_2)
  run_cmd --opt2
  ;;
$option_3)
  run_cmd --opt3
  ;;
$option_4)
  run_cmd --opt4
  ;;
$option_5)
  run_cmd --opt5
  ;;
esac
