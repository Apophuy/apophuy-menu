/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigami as Kirigami

Item {
    id: root

    required property string actionId
    required property var design
    required property string iconSource

    property bool pressed: false
    property real size: Kirigami.Units.iconSizes.medium

    implicitHeight: root.size
    implicitWidth: root.size

    Rectangle {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 2
        width: root.size
        height: width
        color: root.design.actionShadowColor(root.actionId)
        radius: Kirigami.Units.cornerRadius
    }

    Rectangle {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: root.pressed ? 2 : 0
        width: root.size
        height: width
        radius: Kirigami.Units.cornerRadius

        gradient: Gradient {
            GradientStop {
                color: root.design.actionTopColor(root.actionId)
                position: 0
            }
            GradientStop {
                color: root.design.actionColor(root.actionId)
                position: 0.5
            }
            GradientStop {
                color: root.design.actionShadowColor(root.actionId)
                position: 1
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.right: parent.right
            anchors.rightMargin: 2
            anchors.top: parent.top
            anchors.topMargin: 2
            height: Math.max(2, parent.height * 0.27)
            color: Qt.rgba(1, 1, 1, 0.16)
            radius: Kirigami.Units.cornerRadius
        }

        Kirigami.Icon {
            anchors.centerIn: parent
            width: Kirigami.Units.iconSizes.small
            height: width
            color: "#ffffff"
            isMask: true
            source: root.iconSource
        }
    }
}
