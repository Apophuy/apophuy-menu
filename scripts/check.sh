#!/bin/sh

# SPDX-FileCopyrightText: 2026 Apophuy
# SPDX-License-Identifier: GPL-3.0-or-later

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_dir=$(dirname -- "$script_dir")
package_dir="$project_dir/package"

find_qt_tool() {
    tool_name=$1
    qt_host_bins=$(qtpaths6 --query QT_HOST_BINS)

    if [ -x "$qt_host_bins/$tool_name" ]; then
        printf '%s\n' "$qt_host_bins/$tool_name"
        return
    fi

    if command -v "$tool_name" >/dev/null 2>&1; then
        command -v "$tool_name"
        return
    fi

    printf 'Required Qt tool not found: %s\n' "$tool_name" >&2
    exit 1
}

qmlformat=$(find_qt_tool qmlformat)
qmllint=$(find_qt_tool qmllint)

python3 -m json.tool "$package_dir/metadata.json" >/dev/null

translation_template="$project_dir/translations/apophuy-application-launcher.pot"

find "$project_dir/translations" -type f -name '*.po' -print | sort | while IFS= read -r translation_file; do
    msgfmt --check --check-compatibility --output-file=/dev/null "$translation_file"
    msgcmp --no-fuzzy-matching "$translation_file" "$translation_template"
done

msgcat --output-file=/dev/null "$translation_template"

find "$package_dir/contents" -type f -name '*.xml' -print | sort | while IFS= read -r xml_file; do
    xmllint --noout "$xml_file"
done

find "$package_dir/contents" -type f -name '*.qml' -print | sort | while IFS= read -r qml_file; do
    "$qmlformat" "$qml_file" >/dev/null
    "$qmllint" -I "$(qtpaths6 --query QT_INSTALL_QML)" "$qml_file"
done

kpackagetool6 --hash "$package_dir" >/dev/null

printf 'Package checks passed.\n'
