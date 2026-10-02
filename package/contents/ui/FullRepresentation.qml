/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid

FocusScope {
    id: root

    required property PlasmoidItem appletRoot

    implicitWidth: Kirigami.Units.gridUnit * 22
    implicitHeight: Kirigami.Units.gridUnit * 26

    Layout.minimumWidth: Kirigami.Units.gridUnit * 16
    Layout.minimumHeight: Kirigami.Units.gridUnit * 18
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight

    activeFocusOnTab: true
    focus: true

    Keys.onEscapePressed: event => {
        root.appletRoot.expanded = false;
        event.accepted = true;
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Kirigami.Units.largeSpacing

        Kirigami.Icon {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: Kirigami.Units.iconSizes.huge
            Layout.preferredHeight: Kirigami.Units.iconSizes.huge

            source: "start-here-kde"
        }

        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignHCenter

            text: i18n("Apophuy Application Launcher")
        }

        PlasmaComponents.Label {
            Layout.alignment: Qt.AlignHCenter

            text: i18n("Minimal launcher shell")
        }

        PlasmaComponents.Button {
            Layout.alignment: Qt.AlignHCenter

            text: i18n("Close")
            onClicked: root.appletRoot.expanded = false
        }
    }
}
