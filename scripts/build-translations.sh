#!/bin/sh

# SPDX-FileCopyrightText: 2026 Apophuy
# SPDX-License-Identifier: GPL-3.0-or-later

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_dir=$(dirname -- "$script_dir")
translations_dir="$project_dir/translations"
locale_dir="$project_dir/package/contents/locale"
domain=plasma_applet_io.github.apophuy.applicationlauncher

for po_file in "$translations_dir"/*.po; do
    language=$(basename "$po_file" .po)
    output_dir="$locale_dir/$language/LC_MESSAGES"

    mkdir -p "$output_dir"
    msgfmt --check --check-compatibility --output-file="$output_dir/$domain.mo" "$po_file"
done

printf 'Built translation catalogs in %s.\n' "$locale_dir"
