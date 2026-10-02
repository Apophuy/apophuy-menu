/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

MouseArea {
    id: root

    required property PlasmoidItem appletRoot

    property bool wasExpanded: false

    implicitWidth: Kirigami.Units.iconSizes.large
    implicitHeight: Kirigami.Units.iconSizes.large

    Layout.minimumWidth: implicitWidth
    Layout.minimumHeight: implicitHeight
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight

    Accessible.name: i18n("Apophuy Application Launcher")
    Accessible.role: Accessible.Button
    hoverEnabled: true

    onPressed: root.wasExpanded = root.appletRoot.expanded
    onClicked: root.appletRoot.expanded = !root.wasExpanded

    Accessible.onPressAction: root.appletRoot.expanded = !root.appletRoot.expanded

    Kirigami.Icon {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.smallSpacing

        active: root.containsMouse || root.appletRoot.expanded
        source: Plasmoid.icon
    }
}
