#!/bin/bash

CONFIG_FILE="$HOME/.config/i3/audio-sinks.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Config file not found: $CONFIG_FILE"
    exit 1
fi

source "$CONFIG_FILE"

if [[ -z "$PRIMARY_SINK" || -z "$SECONDARY_SINK" ]]; then
    echo "PRIMARY_SINK or SECONDARY_SINK not set in config"
    exit 1
fi

CURRENT_SINK=$(pactl get-default-sink)

if [[ "$CURRENT_SINK" == "$PRIMARY_SINK" ]]; then
    NEW_SINK="$SECONDARY_SINK"
    LABEL="Secondary"
else
    NEW_SINK="$PRIMARY_SINK"
    LABEL="Primary"
fi

pactl set-default-sink "$NEW_SINK"

pactl list short sink-inputs | while read stream; do
    STREAM_ID=$(echo "$stream" | cut -f1)
    pactl move-sink-input "$STREAM_ID" "$NEW_SINK" 2>/dev/null
done

polybar-msg action audio-output hook 0 >/dev/null 2>&1

