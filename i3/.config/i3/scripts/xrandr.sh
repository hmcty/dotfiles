#!/bin/bash

primary=DP-4
secondary=HDMI-0

xrandr --output "$primary" --primary --mode 1920x1080 --rate 144.00 --output "$secondary" --right-of "$primary" --auto
