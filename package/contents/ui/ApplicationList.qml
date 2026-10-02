/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

ListView {
    id: root

    required property var applicationModel
    required property var appletRoot

    activeFocusOnTab: true
    clip: true
    currentIndex: count > 0 ? 0 : -1
    keyNavigationWraps: true
    model: root.applicationModel
    spacing: Kirigami.Units.smallSpacing

    delegate: ApplicationDelegate {
        applicationModel: root.applicationModel
        appletRoot: root.appletRoot
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
        visible: root.count === 0
        text: i18n("No applications in this category")
    }
}
