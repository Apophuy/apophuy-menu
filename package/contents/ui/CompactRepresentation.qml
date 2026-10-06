/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

MouseArea {
    id: root

    required property PlasmoidItem appletRoot

    property int iconVariant: 1
    property color penguinAccentColor: "#39d641"
    property bool penguinUsesOriginalColor: true
    property bool wasExpanded: false

    readonly property bool vertical: Plasmoid.location === PlasmaCore.Types.LeftEdge || Plasmoid.location === PlasmaCore.Types.RightEdge

    // Plasma's CompactApplet uses the same dynamic applet-container contract.
    // qmllint disable missing-property
    function panelMargin(edge: string): real {
        let item = root;
        while (item.parent) {
            item = item.parent;
            if (item["isAppletContainer"]) {
                return item["getMargins"](edge, true);
            }
        }
        return 0;
    }
    // qmllint enable missing-property

    implicitWidth: Kirigami.Units.iconSizes.large
    implicitHeight: Kirigami.Units.iconSizes.large

    Layout.minimumWidth: implicitWidth
    Layout.minimumHeight: implicitHeight
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight

    Accessible.name: i18n("Apophuy Menu")
    Accessible.role: Accessible.Button
    activeFocusOnTab: true
    hoverEnabled: true

    Keys.onPressed: event => {
        switch (event.key) {
        case Qt.Key_Space:
        case Qt.Key_Enter:
        case Qt.Key_Return:
        case Qt.Key_Select:
            root.appletRoot.expanded = !root.appletRoot.expanded;
            event.accepted = true;
            break;
        }
    }

    onPressed: root.wasExpanded = root.appletRoot.expanded
    onClicked: root.appletRoot.expanded = !root.wasExpanded

    Accessible.onPressAction: root.appletRoot.expanded = !root.appletRoot.expanded

    Rectangle {
        anchors {
            fill: parent
            bottomMargin: !root.vertical ? -root.panelMargin("bottom") : 0
            leftMargin: root.vertical ? -root.panelMargin("left") : 0
            rightMargin: root.vertical ? -root.panelMargin("right") : 0
            topMargin: !root.vertical ? -root.panelMargin("top") : 0
        }
        border.color: root.appletRoot.expanded || root.activeFocus ? Qt.alpha(Kirigami.Theme.focusColor, 0.9) : (root.containsMouse ? Qt.alpha(Kirigami.Theme.textColor, 0.28) : "transparent")
        border.width: root.appletRoot.expanded || root.activeFocus ? 2 : (root.containsMouse ? 1 : 0)
        color: root.appletRoot.expanded ? Qt.alpha(Kirigami.Theme.highlightColor, 0.28) : (root.containsMouse ? Qt.alpha(Kirigami.Theme.hoverColor, 0.2) : "transparent")
        radius: Kirigami.Units.cornerRadius * 2
    }

    LauncherIcon {
        anchors.fill: parent

        iconVariant: root.iconVariant
        accentColor: root.penguinAccentColor
        useOriginalColor: root.penguinUsesOriginalColor
    }
}
