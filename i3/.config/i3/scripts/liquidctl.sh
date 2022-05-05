#!/bin/bash

if [ "$DEVICE" == "desktop" ]
then
    sudo -u "$USER" liquidctl set fan speed 20 0 30 0 35 5 40 15 50 25 55 75
fi
