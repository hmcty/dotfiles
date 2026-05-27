#!/bin/sh
screenshots_dir="$HOME/Screenshots"
output="$screenshots_dir/maim_$(date '+%Y-%m-%d_%H-%M-%S').png"

mkdir -p "$screenshots_dir"
maim --select "$output" &&
  xclip -selection clipboard -t image/png -i "$output"
