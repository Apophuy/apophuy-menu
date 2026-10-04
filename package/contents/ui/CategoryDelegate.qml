/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

PlasmaComponents.ItemDelegate {
    id: root

    required property int index
    required property var model
    required property var design

    signal activated(int row)

    width: ListView.view.width
    implicitHeight: Kirigami.Units.gridUnit * 2.1
    bottomPadding: Math.round(Kirigami.Units.smallSpacing / 2)
    highlighted: ListView.isCurrentItem
    icon.name: root.model.decoration || "applications-other"
    leftPadding: Kirigami.Units.largeSpacing
    rightPadding: Kirigami.Units.largeSpacing
    text: root.model.display
    topPadding: Math.round(Kirigami.Units.smallSpacing / 2)

    Kirigami.Theme.highlightedTextColor: root.design.selectedText
    Kirigami.Theme.textColor: root.highlighted ? root.design.selectedText : root.design.primaryText

    background: DelegateBackground {
        control: root
        design: root.design
    }

    Accessible.description: i18n("Show applications in %1", root.model.display)

    onClicked: {
        ListView.view.currentIndex = root.index;
        root.activated(root.index);
    }

    Accessible.onPressAction: root.clicked()
}
