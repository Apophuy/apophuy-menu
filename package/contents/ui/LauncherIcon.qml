/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import org.kde.kirigami as Kirigami

Item {
    id: root

    property color accentColor: "#39d641"
    property bool useOriginalColor: true
    property bool useSystemIcon: false

    implicitWidth: Kirigami.Units.iconSizes.large
    implicitHeight: Kirigami.Units.iconSizes.large

    Image {
        id: penguin

        anchors.fill: parent
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        mipmap: true
        smooth: true
        source: Qt.resolvedUrl("../images/launcher/penguin.png")
        sourceSize.width: 512
        sourceSize.height: 512
        visible: !root.useSystemIcon
    }

    Image {
        id: penguinAccentMask

        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        mipmap: true
        smooth: true
        source: Qt.resolvedUrl("../images/launcher/penguin-accent-mask.png")
        sourceSize.width: 512
        sourceSize.height: 512
        visible: false
    }

    MultiEffect {
        anchors.fill: penguin

        colorization: 1
        colorizationColor: root.accentColor
        maskEnabled: true
        maskSource: penguinAccentMask
        source: penguin
        visible: !root.useSystemIcon && !root.useOriginalColor
    }

    Kirigami.Icon {
        anchors.fill: parent

        source: "start-here-kde"
        visible: root.useSystemIcon
    }
}
