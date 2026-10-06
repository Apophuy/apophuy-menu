/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: root

    required property string iconName

    Layout.preferredHeight: Kirigami.Units.iconSizes.medium
    Layout.preferredWidth: Layout.preferredHeight

    Kirigami.Icon {
        anchors.fill: parent

        source: root.iconName
    }
}
