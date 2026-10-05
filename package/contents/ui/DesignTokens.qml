/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    id: root

    required property int themeMode
    required property color systemBackground
    required property color systemHighlight
    required property color systemHighlightedText
    required property color systemNegative
    required property color systemNeutral
    required property color systemPositive
    required property color systemText

    readonly property bool dark: root.themeMode === 2 || (root.themeMode === 0 && root.luminance(root.systemBackground) < 0.5)

    readonly property color background: root.themeMode === 0 ? root.systemBackground : (root.dark ? "#1b2028" : "#f6f8fb")
    readonly property color elevatedBackground: root.themeMode === 0 ? root.blend(root.background, root.dark ? root.primaryText : "#ffffff", root.dark ? 0.06 : 0.42) : (root.dark ? "#252b34" : "#ffffff")
    readonly property color primaryText: root.themeMode === 0 ? root.systemText : (root.dark ? "#f3f5f7" : "#1b2027")
    readonly property color secondaryText: root.themeMode === 0 ? root.blend(root.primaryText, root.background, 0.34) : (root.dark ? "#aeb7c3" : "#5d6775")
    readonly property color border: root.themeMode === 0 ? root.blend(root.background, root.primaryText, root.dark ? 0.22 : 0.18) : (root.dark ? "#46515f" : "#cfd6df")
    readonly property color hover: root.themeMode === 0 ? root.blend(root.background, root.accent, root.dark ? 0.28 : 0.11) : (root.dark ? "#36485a" : "#e7eef7")
    readonly property color hoverBorder: root.dark ? root.blend(root.border, root.primaryText, 0.32) : root.border
    readonly property color selected: root.themeMode === 0 ? root.blend(root.background, root.systemHighlight, root.dark ? 0.46 : 0.26) : (root.dark ? "#2b4a6a" : "#d7e8fb")
    readonly property color selectedText: root.themeMode === 0 ? root.primaryText : (root.dark ? "#ffffff" : "#14324d")
    readonly property color accent: root.themeMode === 0 ? root.systemHighlight : (root.dark ? "#69a9e8" : "#2563a9")
    readonly property color success: root.themeMode === 0 ? root.systemPositive : (root.dark ? "#59bd7b" : "#2f7d4a")
    readonly property color warning: root.themeMode === 0 ? root.systemNeutral : (root.dark ? "#f0a54a" : "#9a5700")
    readonly property color favorite: root.dark ? "#f6c744" : "#a86d00"
    readonly property color destructive: root.themeMode === 0 ? root.systemNegative : (root.dark ? "#ec6a72" : "#b5333c")
    readonly property color focus: root.accent

    function blend(first: color, second: color, amount: real): color {
        const boundedAmount = Math.max(0, Math.min(1, amount));
        return Qt.rgba(first.r + (second.r - first.r) * boundedAmount, first.g + (second.g - first.g) * boundedAmount, first.b + (second.b - first.b) * boundedAmount, first.a + (second.a - first.a) * boundedAmount);
    }

    function luminance(value: color): real {
        return 0.2126 * value.r + 0.7152 * value.g + 0.0722 * value.b;
    }

    function actionColor(actionId: string): color {
        switch (actionId) {
        case "lock-screen":
            return "#9c6500";
        case "logout":
            return "#28796f";
        case "suspend":
            return "#2f6eaa";
        case "hibernate":
            return "#6650a8";
        case "reboot":
            return "#a94e12";
        case "shutdown":
            return "#b5333c";
        case "switch-user":
            return "#247b8f";
        case "save-session":
            return "#357a4e";
        default:
            return root.accent;
        }
    }

    function actionTopColor(actionId: string): color {
        return root.blend(root.actionColor(actionId), "#ffffff", 0.2);
    }

    function actionShadowColor(actionId: string): color {
        return root.blend(root.actionColor(actionId), "#000000", 0.36);
    }
}
