#!/bin/bash

get_volume() {
    if pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes"; then
        printf '%%{F#707880}muted%%{F-}\n'
    else
        pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1
    fi
}

get_volume

pactl subscribe 2>/dev/null | while IFS= read -r line; do
    if echo "$line" | grep -qE "on (sink|server)"; then
        get_volume
    fi
done
