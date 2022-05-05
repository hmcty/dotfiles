#!/usr/bin/env bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done

case $DEVICE in
    desktop)
        if type "xrandr" > /dev/null; then
            for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
                if [ $m == 'DP-4' ] 
                then		
                    MONITOR=$m polybar top-primary &	
                else
                    MONITOR=$m polybar top-secondary &
                fi     
            done
        else
            polybar top-primary &
        fi
        ;;

    *)
        polybar top-primary &
        ;;
esac