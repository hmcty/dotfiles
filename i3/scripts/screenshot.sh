#!/bin/sh
output="$HOME/Screenshots/maim_$(date '+%Y-%m-%d_%H-%M-%S').png"

maim --select "$output" &&
  xclip -selection clipboard -t image/png -i "$output"
