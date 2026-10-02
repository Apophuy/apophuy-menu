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

    signal activated(int row)

    width: ListView.view.width
    highlighted: ListView.isCurrentItem
    icon.name: root.model.decoration || "applications-other"
    text: root.model.display

    Accessible.description: i18n("Show applications in %1", root.model.display)

    onClicked: {
        ListView.view.currentIndex = root.index;
        root.activated(root.index);
    }

    Accessible.onPressAction: root.clicked()
}
