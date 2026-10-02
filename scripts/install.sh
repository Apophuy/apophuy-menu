#!/bin/sh

# SPDX-FileCopyrightText: 2026 Apophuy
# SPDX-License-Identifier: GPL-2.0-or-later

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_dir=$(dirname -- "$script_dir")
package_dir="$project_dir/package"
plugin_id=io.github.apophuy.applicationlauncher

if kpackagetool6 --type Plasma/Applet --show "$plugin_id" >/dev/null 2>&1; then
    kpackagetool6 --type Plasma/Applet --upgrade "$package_dir"
else
    kpackagetool6 --type Plasma/Applet --install "$package_dir"
fi

printf 'Installed %s for the current user.\n' "$plugin_id"
