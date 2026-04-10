#!/bin/bash

CONFIG_FILE="$HOME/.config/i3/audio-sinks.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "?"
    exit 0
fi

source "$CONFIG_FILE"

CURRENT_SINK=$(pactl get-default-sink)

if [[ "$CURRENT_SINK" == "$PRIMARY_SINK" ]]; then
    echo "Pri"
elif [[ "$CURRENT_SINK" == "$SECONDARY_SINK" ]]; then
    echo "Sec"
else
    echo "?"
fi
