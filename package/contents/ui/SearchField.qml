/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

PlasmaComponents.TextField {
    id: root

    required property var design

    signal downRequested
    signal escapeRequested
    signal queryEdited(string query)

    Accessible.name: i18n("Search applications")
    bottomPadding: Kirigami.Units.smallSpacing
    color: root.design.primaryText
    leftPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    placeholderText: i18n("Search applications…")
    placeholderTextColor: root.design.secondaryText
    rightPadding: Kirigami.Units.largeSpacing + Kirigami.Units.smallSpacing
    topPadding: Kirigami.Units.smallSpacing

    background: Rectangle {
        border.color: root.activeFocus ? root.design.focus : root.design.border
        border.width: root.activeFocus ? 2 : 1
        color: root.design.elevatedBackground
        radius: Kirigami.Units.cornerRadius
    }

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
