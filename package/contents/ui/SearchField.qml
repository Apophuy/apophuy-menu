/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.plasma.components as PlasmaComponents

PlasmaComponents.TextField {
    id: root

    signal downRequested
    signal escapeRequested
    signal queryEdited(string query)

    Accessible.name: i18n("Search applications")
    placeholderText: i18n("Search applications…")

    onTextChanged: root.queryEdited(root.text)

    Keys.onDownPressed: event => {
        root.downRequested();
        event.accepted = true;
    }
    Keys.onEscapePressed: event => {
        root.escapeRequested();
        event.accepted = true;
    }
}
