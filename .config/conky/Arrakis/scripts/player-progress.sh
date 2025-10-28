#!/bin/bash

#=============================================
# Version : 1.3
# Author  : Closebox73
# Desc    : Return song progress percentage
#           for use in Conky ${execbar}
#=============================================

pos_str=$(playerctl position 2>/dev/null)
len_micro=$(playerctl metadata mpris:length 2>/dev/null)

# Convert HH:MM:SS to seconds
time_to_sec() {
    if [[ "$1" == *:*:* ]]; then
        IFS=: read -r h m s <<< "$1"
        echo $((10#$h * 3600 + 10#$m * 60 + 10#${s%.*}))
    elif [[ "$1" == *:* ]]; then
        IFS=: read -r m s <<< "$1"
        echo $((10#$m * 60 + 10#${s%.*}))
    else
        echo "${1%.*}"  # Detik float → buang desimal
    fi
}

if [[ -n "$pos_str" && -n "$len_micro" && "$len_micro" -gt 0 ]]; then
    pos_sec=$(time_to_sec "$pos_str")
    len_sec=$((len_micro / 1000000))
    percent=$((100 * pos_sec / len_sec))
    echo "$percent"
else
    echo "0"
fi

exit 0
