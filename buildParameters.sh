#!/bin/bash

# Copyright (c) 2022, Thaddeus Ryker.
# Copied from the ToastStunt docker project and modified
# Contains many contributions by Lisdude (massive thanks to him) to be more functional and handle quotes properly
# This script handles building the command line parameters for the moo binary execution based on the defined environmental variables.

declare -a CONFIG_PARAMS=()
declare -a PORT_PARAMS=()

if [ "$EMERGENCY_MODE" = "true" ]; then
    CONFIG_PARAMS+=("-e")
fi
if [ ! -z "$PORT" ]; then
    PORT_PARAMS+=("${PORT}")
fi

export PORT_PARAMS
export CONFIG_PARAMS