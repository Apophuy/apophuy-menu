/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

RowLayout {
    id: root

    required property var appletRoot
    required property var design
    required property var systemModel

    property bool compact: false

    spacing: root.compact ? Math.round(Kirigami.Units.smallSpacing / 2) : Kirigami.Units.smallSpacing

    Repeater {
        model: root.systemModel

        delegate: PlasmaComponents.ToolButton {
            id: actionButton

            required property int index
            required property var model

            readonly property string actionId: model.favoriteId || ""
            readonly property color actionColor: root.design.actionColor(actionId)

            Layout.fillWidth: true
            Layout.fillHeight: true

            Accessible.name: model.display
            display: PlasmaComponents.AbstractButton.IconOnly
            enabled: !model.disabled
            focusPolicy: Qt.StrongFocus
            text: model.display

            background: Rectangle {
                border.color: actionButton.activeFocus ? root.design.focus : "transparent"
                border.width: actionButton.activeFocus ? 2 : 0
                color: actionButton.down ? root.design.selected : (actionButton.hovered ? root.design.hover : "transparent")
                radius: Kirigami.Units.cornerRadius
            }

            contentItem: Item {
                Rectangle {
                    id: tileShadow

                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 2
                    width: root.compact ? Kirigami.Units.iconSizes.smallMedium : Kirigami.Units.iconSizes.medium
                    height: width
                    color: root.design.actionShadowColor(actionButton.actionId)
                    radius: Kirigami.Units.cornerRadius
                }

                Rectangle {
                    id: tileFace

                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: actionButton.down ? 2 : 0
                    width: root.compact ? Kirigami.Units.iconSizes.smallMedium : Kirigami.Units.iconSizes.medium
                    height: width
                    radius: Kirigami.Units.cornerRadius

                    gradient: Gradient {
                        GradientStop {
                            color: root.design.actionTopColor(actionButton.actionId)
                            position: 0
                        }
                        GradientStop {
                            color: actionButton.actionColor
                            position: 0.5
                        }
                        GradientStop {
                            color: root.design.actionShadowColor(actionButton.actionId)
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
                        width: root.compact ? Kirigami.Units.iconSizes.small : Kirigami.Units.iconSizes.smallMedium
                        height: width
                        color: "#ffffff"
                        isMask: true
                        source: actionButton.model.decoration
                    }
                }
            }

            PlasmaComponents.ToolTip.text: model.display
            PlasmaComponents.ToolTip.delay: Kirigami.Units.toolTipDelay
            PlasmaComponents.ToolTip.visible: hovered

            onClicked: {
                if (root.systemModel.trigger(index, "", null)) {
                    root.appletRoot.expanded = false;
                }
            }
        }
    }
}
