#!/bin/sh

# SPDX-FileCopyrightText: 2026 Apophuy
# SPDX-License-Identifier: GPL-2.0-or-later

set -eu

plugin_id=io.github.apophuy.applicationlauncher

kpackagetool6 --type Plasma/Applet --remove "$plugin_id"
printf 'Removed %s from the current user installation.\n' "$plugin_id"
