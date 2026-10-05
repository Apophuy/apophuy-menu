#!/bin/sh

# SPDX-FileCopyrightText: 2026 Apophuy
# SPDX-License-Identifier: GPL-2.0-or-later

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_dir=$(dirname -- "$script_dir")
package_dir="$project_dir/package"
metadata_file="$package_dir/metadata.json"
dist_dir="$project_dir/dist"

version=$(python3 -c 'import json, sys; print(json.load(open(sys.argv[1], encoding="utf-8"))["KPlugin"]["Version"])' "$metadata_file")
archive="$dist_dir/apophuy-application-launcher-$version.plasmoid"
checksum="$archive.sha256"
temporary_archive="$dist_dir/.apophuy-application-launcher-$version.plasmoid.tmp"

"$script_dir/build-translations.sh"
"$script_dir/check.sh"
mkdir -p "$dist_dir"

(cd "$package_dir" && zip -X -q -r "$temporary_archive" .)
mv -f "$temporary_archive" "$archive"

unzip -tq "$archive" >/dev/null
(
    cd "$dist_dir"
    sha256sum "$(basename -- "$archive")" >"$(basename -- "$checksum")"
)
printf 'Created %s\n' "$archive"
printf 'Created %s\n' "$checksum"
