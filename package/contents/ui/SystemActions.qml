/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents

RowLayout {
    id: root

    required property var appletRoot
    required property var systemModel

    spacing: 0

    Repeater {
        model: root.systemModel

        delegate: PlasmaComponents.ToolButton {
            required property int index
            required property var model

            Layout.fillWidth: true

            Accessible.name: model.display
            display: PlasmaComponents.AbstractButton.IconOnly
            enabled: !model.disabled
            icon.name: model.decoration

            PlasmaComponents.ToolTip.text: model.display
            PlasmaComponents.ToolTip.visible: hovered

            onClicked: {
                if (root.systemModel.trigger(index, "", null)) {
                    root.appletRoot.expanded = false;
                }
            }
        }
    }
}
