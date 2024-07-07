#!/usr/bin/env bash

# Parts of code yanked from a custom build script I made

# Print to `STDERR`, separate each arg with newline
error() {
    local TXT=("$@")
    printf "%s\n" "${TXT[@]}" >&2
    return 0
}

# Check whether a console command (or multiple) exists
# Returns 0 if all commands are found
# Returns 1 if at least one command is not found
# Returns 127 if no arguments were given
_cmd() {
    if [[ $# -eq 1 ]]; then
        command -v "$1" &> /dev/null
        return $?
    elif [[ $# -gt 1 ]]; then
        local STATUS=0

        while [[ $# -gt 0 ]] && [[ $STATUS -eq 0 ]]; do
            command -v "$1" &> /dev/null || STATUS=1
            shift
        done

        return $STATUS
    fi

    return 127
}

# Terminate the script, optionally set the exit code and abort message
die() {
    local EC=1

    # TODO: Sanitize this line
    while [[ "$(pwd)" == *"nvim/"* ]] || [[ "$(pwd)" == *"neovim/"* ]]; do
        cd ..
    done

    if [[ $# -ge 1 ]] && [[ $1 =~ ^(0|-?[1-9][0-9]*)$ ]]; then
        EC=$1
        shift
    fi

    if [[ $# -ge 1 ]]; then
        local TXT=("$@")
        if [[ $EC -eq 0 ]]; then
            printf "%s\n" "${TXT[@]}"
        else
            error "${TXT[@]}"
        fi
    fi

    exit "$EC"
}

[[ $# -eq 0 ]] && error "No arguments were given. Aborting" && exit 127

EC=0
while [[ $# -gt 0 ]]; do
    if ! [[ "$1" =~ ^s/.+/.*/g?$ ]] ; then
        error "Pattern \`$1\` not valid. Skipping..."
        EC=1
        shift
        continue
    fi

    REGEX="$1"

    printf "\n%s\n" "Applying regex ${REGEX}:"
    for F in $(find . -type f -regex '.*\.lua$' | cut -d '/' -f2-); do
        echo -e "    ==> ${F}"
        if ! sed -i "${REGEX}" "$F"; then
            error "Unable to replace contents of file \`$F\`. Skipping pattern \`$REGEX\`"
            EC=1
            break
        fi
    done

    shift
done

die "$EC"
