#!/bin/sh

# Copyright 2021-2022 The MathWorks, Inc.

. $(dirname "$0")/utils.sh

# Initialize BROWSER mode as true by default
BROWSER=true
CUSTOM=false

modes=0
if [ $# -ne 0 ]; then
    if [ $(echo "-help" | grep -Eo "^$1$") ] ||
        [ $(echo "-vnc" | grep -Eo "^$1$") ] ||
        [ $(echo "-shell" | grep -Eo "^$1$") ] ||
        [ $(echo "-browser" | grep -Eo "^$1$") ] ||
        [ $(echo "-batch" | grep -Eo "^$1$") ]; then
        CUSTOM=false
    else
        CUSTOM=true
    fi
fi

if [ "$CUSTOM" = false ]; then
    while [ $# -gt 0 ]; do
        case "$1" in
        -help)
            HELP=true
            BROWSER=false
            modes=$((modes + 1))
            ;;
        -vnc)
            VNC=true
            BROWSER=false
            modes=$((modes + 1))
            ;;
        -shell)
            SHELL=true
            BROWSER=false
            modes=$((modes + 1))
            ;;
        -browser)
            BROWSER=true
            modes=$((modes + 1))
            ;;
        -batch)
            BATCH=true
            BROWSER=false
            BATCH_COMMAND=$(build_cmd "$2")
            modes=$((modes + 1))
            ;;
        esac
        shift
    done
else
    CUSTOM_COMMAND=$(build_cmds "$@")
fi

validateInput
checkLicensing
checkSharedMemorySpace
checkEnvironmentVariables
startContainer

exit
