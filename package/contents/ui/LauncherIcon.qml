/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import org.kde.kirigami as Kirigami

Item {
    id: root

    property color accentColor: "#39d641"
    property int iconVariant: 1
    property bool useOriginalColor: true

    readonly property bool usesSystemIcon: root.iconVariant === 2

    implicitWidth: Kirigami.Units.iconSizes.large
    implicitHeight: Kirigami.Units.iconSizes.large

    Image {
        id: penguin

        anchors.fill: parent
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        mipmap: true
        smooth: true
        source: root.iconVariant === 0
                ? Qt.resolvedUrl("../images/launcher/penguin.png")
                : Qt.resolvedUrl("../images/launcher/penguin-flat.png")
        sourceSize.width: 512
        sourceSize.height: 512
        visible: !root.usesSystemIcon
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
        maskEnabled: root.iconVariant === 0
        maskSource: penguinAccentMask
        source: penguin
        visible: !root.usesSystemIcon && !root.useOriginalColor
    }

    Kirigami.Icon {
        anchors.fill: parent

        source: "start-here-kde"
        visible: root.usesSystemIcon
    }
}
