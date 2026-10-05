/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigami as Kirigami

Item {
    id: root

    readonly property color background: root.colorOrFallback(root.Kirigami.Theme.backgroundColor, "#20252d")
    readonly property color highlight: root.colorOrFallback(root.Kirigami.Theme.highlightColor, "#3f88c5")
    readonly property color highlightedText: root.colorOrFallback(root.Kirigami.Theme.highlightedTextColor, "#ffffff")
    readonly property color negative: root.colorOrFallback(root.Kirigami.Theme.negativeTextColor, "#e35d6a")
    readonly property color neutral: root.colorOrFallback(root.Kirigami.Theme.neutralTextColor, "#e7a13d")
    readonly property color positive: root.colorOrFallback(root.Kirigami.Theme.positiveTextColor, "#55b879")
    readonly property color text: root.colorOrFallback(root.Kirigami.Theme.textColor, "#f4f6f8")

    visible: false

    Kirigami.Theme.colorSet: Kirigami.Theme.Window
    Kirigami.Theme.inherit: false

    function colorOrFallback(value: var, fallback: color): color {
        return value === undefined || value === null ? fallback : value;
    }
}
