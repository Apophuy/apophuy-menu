#!/bin/sh

# SPDX-FileCopyrightText: 2026 Apophuy
# SPDX-License-Identifier: GPL-2.0-or-later

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_dir=$(dirname -- "$script_dir")
translations_dir="$project_dir/translations"
template="$translations_dir/apophuy-application-launcher.pot"

mkdir -p "$translations_dir"

(cd "$project_dir" && find package/contents -type f -name '*.qml' -print | sort) | \
    xgettext \
        --files-from=- \
        --from-code=UTF-8 \
        --language=JavaScript \
        --keyword=i18n:1 \
        --keyword=i18nc:1c,2 \
        --keyword=i18np:1,2 \
        --keyword=i18ncp:1c,2,3 \
        --package-name='Apophuy Application Launcher' \
        --copyright-holder='Apophuy' \
        --output="$template"

for po_file in "$translations_dir"/*.po; do
    msgmerge --quiet --update --backup=none "$po_file" "$template"
done

printf 'Updated %s and merged existing translations.\n' "$template"
