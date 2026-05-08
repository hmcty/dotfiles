#!/bin/bash

CONFIG_FILE="$HOME/.config/i3/audio-sinks.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    exit 0
fi

source "$CONFIG_FILE"

CURRENT_SINK=$(pactl get-default-sink)

if [[ "$CURRENT_SINK" == "$PRIMARY_SINK" ]]; then
    echo "%{F#F0C674}OUT%{F-} Pri"
elif [[ "$CURRENT_SINK" == "$SECONDARY_SINK" ]]; then
    echo "%{F#F0C674}OUT%{F-} Sec"
fi
