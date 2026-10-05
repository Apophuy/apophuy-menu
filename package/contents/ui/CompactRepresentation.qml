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

    property int iconVariant: 0
    property color penguinAccentColor: "#39d641"
    property bool penguinUsesOriginalColor: true
    property bool wasExpanded: false

    implicitWidth: Kirigami.Units.iconSizes.large
    implicitHeight: Kirigami.Units.iconSizes.large

    Layout.minimumWidth: implicitWidth
    Layout.minimumHeight: implicitHeight
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight

    Accessible.name: i18n("Apophuy Application Launcher")
    Accessible.role: Accessible.Button
    activeFocusOnTab: true
    hoverEnabled: true

    Keys.onPressed: event => {
        switch (event.key) {
        case Qt.Key_Space:
        case Qt.Key_Enter:
        case Qt.Key_Return:
        case Qt.Key_Select:
            root.appletRoot.expanded = !root.appletRoot.expanded;
            event.accepted = true;
            break;
        }
    }

    onPressed: root.wasExpanded = root.appletRoot.expanded
    onClicked: root.appletRoot.expanded = !root.wasExpanded

    Accessible.onPressAction: root.appletRoot.expanded = !root.appletRoot.expanded

    Rectangle {
        anchors.fill: parent
        border.color: root.activeFocus ? Kirigami.Theme.focusColor : "transparent"
        border.width: root.activeFocus ? 2 : 0
        color: root.appletRoot.expanded ? Qt.alpha(Kirigami.Theme.highlightColor, 0.28) : (root.containsMouse ? Qt.alpha(Kirigami.Theme.hoverColor, 0.2) : "transparent")
        radius: width / 2
    }

    LauncherIcon {
        anchors.fill: parent

        iconVariant: root.iconVariant
        accentColor: root.penguinAccentColor
        useOriginalColor: root.penguinUsesOriginalColor
    }
}
