#!/bin/bash

# Tailscale mark from fonts/tailscale-glyph. ICON_DIM is a zero-width overlay,
# so printing it before ICON_BRIGHT paints the two-tone logo.
ICON_DIM=$'\uE100'
ICON_BRIGHT=$'\uE101'
ICON_ALL=$'\uE102'

PRIMARY='#F0C674'
DISABLED='#707880'
ALERT='#A54242'

print_connected() {
    printf '%%{F%s}%s%%{F-}%%{F%s}%s%%{F-}\n' \
        "$DISABLED" "$ICON_DIM" "$PRIMARY" "$ICON_BRIGHT"
}

print_all() {
    printf '%%{F%s}%s%%{F-}\n' "$1" "$ICON_ALL"
}

if ! command -v tailscale >/dev/null 2>&1; then
    exit 0
fi

if ! status=$(tailscale status --json --peers=false 2>/dev/null); then
    print_all "$ALERT"
    exit 0
fi

case "$(grep -oP '"BackendState":\s*"\K[^"]+' <<<"$status")" in
    Running)
        print_connected
        ;;
    Stopped)
        print_all "$DISABLED"
        ;;
    *)
        # NoState, Starting, NeedsLogin, NeedsMachineAuth
        print_all "$PRIMARY"
        ;;
esac
