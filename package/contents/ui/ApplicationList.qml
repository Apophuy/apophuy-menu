/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

GridView {
    id: root

    required property var applicationModel
    required property var appletRoot
    required property var design
    required property string emptyText
    required property var favoritesModel

    readonly property real cellSpacing: Kirigami.Units.largeSpacing

    activeFocusOnTab: true
    cellHeight: Kirigami.Units.gridUnit * 6.5
    cellWidth: width / 3
    clip: true
    currentIndex: count > 0 ? 0 : -1
    keyNavigationWraps: true
    model: root.applicationModel

    delegate: ApplicationDelegate {
        applicationModel: root.applicationModel
        appletRoot: root.appletRoot
        design: root.design
        favoritesModel: root.favoritesModel
        height: root.cellHeight - root.cellSpacing
        width: root.cellWidth - root.cellSpacing
    }

    function triggerCurrent(): void {
        if (root.currentIndex < 0 || !root.applicationModel) {
            return;
        }

        if (root.applicationModel.trigger(root.currentIndex, "", null)) {
            root.appletRoot.expanded = false;
        }
    }

    Keys.onEnterPressed: root.triggerCurrent()
    Keys.onReturnPressed: root.triggerCurrent()
    Keys.onSpacePressed: root.triggerCurrent()

    PlasmaComponents.ScrollBar.vertical: PlasmaComponents.ScrollBar {
        policy: PlasmaComponents.ScrollBar.AsNeeded
    }

    PlasmaComponents.Label {
        anchors.centerIn: parent
        color: root.design.secondaryText
        visible: root.count === 0
        text: root.emptyText
    }
}
