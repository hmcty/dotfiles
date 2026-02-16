#!/bin/sh
scrot "$HOME/Screenshots/scrot_%Y-%m-%d_%H-%M-%S.png" \
  --select -e 'xclip -selection clipboard -t image/png -i $f'
