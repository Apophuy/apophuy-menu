#!/bin/sh

# SPDX-FileCopyrightText: 2026 Apophuy
# SPDX-License-Identifier: GPL-3.0-or-later

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_dir=$(dirname -- "$script_dir")
qt_host_bins=$(qtpaths6 --query QT_HOST_BINS)
qmltestrunner="$qt_host_bins/qmltestrunner"

if [ ! -x "$qmltestrunner" ]; then
    printf 'Required Qt tool not found: qmltestrunner\n' >&2
    exit 1
fi

QT_QPA_PLATFORM=offscreen timeout --signal=TERM --kill-after=2s 30s \
    "$qmltestrunner" -input "$project_dir/tests/qml"
