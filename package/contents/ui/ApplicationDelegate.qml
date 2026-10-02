/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.plasma.components as PlasmaComponents

PlasmaComponents.ItemDelegate {
    id: root

    required property int index
    required property var model
    required property var applicationModel
    required property var appletRoot

    width: ListView.view.width
    enabled: !root.model.disabled
    highlighted: ListView.isCurrentItem
    icon.name: root.model.decoration || "application-x-executable"
    text: root.model.compactName || root.model.display

    Accessible.description: root.model.description || root.model.display

    function trigger(): void {
        ListView.view.currentIndex = root.index;
        if (root.applicationModel.trigger(root.index, "", null)) {
            root.appletRoot.expanded = false;
        }
    }

    onClicked: root.trigger()
    Accessible.onPressAction: root.trigger()
}
