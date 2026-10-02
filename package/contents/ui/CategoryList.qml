/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.plasma.components as PlasmaComponents

ListView {
    id: root

    required property var categoryModel

    signal categoryActivated(int row)

    activeFocusOnTab: true
    clip: true
    currentIndex: 0
    keyNavigationWraps: true
    model: root.categoryModel

    delegate: CategoryDelegate {
        onActivated: row => root.categoryActivated(row)
    }

    Keys.onEnterPressed: root.categoryActivated(root.currentIndex)
    Keys.onReturnPressed: root.categoryActivated(root.currentIndex)
    Keys.onSpacePressed: root.categoryActivated(root.currentIndex)

    PlasmaComponents.ScrollBar.vertical: PlasmaComponents.ScrollBar {
        policy: PlasmaComponents.ScrollBar.AsNeeded
    }
}
