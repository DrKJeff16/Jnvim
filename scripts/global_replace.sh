#!/usr/bin/env bash

[[ $# -eq 0 ]] && exit 1

IFS=$'\n' FILES=($(find . -type f -regex '.*\.lua$' | cut -d '/' -f2-))

while [[ $# -gt 0 ]]; do
    if ! [[ "$1" =~ ^s/.+/.*/g$ ]] ; then
        shift
        continue
    fi

    REGEX="$1"

    for F in "${FILES[@]}"; do
        sed -i "${REGEX}" "$F" || break
    done

    shift
done

exit 0
