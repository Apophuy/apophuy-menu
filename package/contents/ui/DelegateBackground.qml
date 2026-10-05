/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigami as Kirigami

Rectangle {
    id: root

    required property var control
    required property var design

    border.color: root.control.activeFocus ? root.design.focus : (root.control.hovered && !root.control.highlighted ? root.design.hoverBorder : "transparent")
    border.width: root.control.activeFocus ? 2 : (root.control.hovered && !root.control.highlighted ? 1 : 0)
    color: root.control.highlighted || root.control.down ? root.design.selected : (root.control.hovered ? root.design.hover : "transparent")
    radius: Kirigami.Units.cornerRadius
}
