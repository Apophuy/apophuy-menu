/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

PlasmaComponents.ItemDelegate {
    id: root

    required property int index
    required property var model
    required property var design

    signal activated(int row)

    function navigationIconName(modelIcon: var): string {
        const iconName = String(modelIcon || "applications-other").replace("-symbolic", "");
        if (iconName.includes("help")) {
            return "system-help";
        }
        if (iconName.includes("all")) {
            return "applications-all";
        }
        return iconName;
    }

    width: ListView.view.width
    implicitHeight: Kirigami.Units.gridUnit * 2.1
    bottomPadding: Math.round(Kirigami.Units.smallSpacing / 2)
    highlighted: ListView.isCurrentItem
    leftPadding: Kirigami.Units.largeSpacing
    rightPadding: Kirigami.Units.largeSpacing
    text: root.model.display
    topPadding: Math.round(Kirigami.Units.smallSpacing / 2)

    Kirigami.Theme.highlightedTextColor: root.design.selectedText
    Kirigami.Theme.textColor: root.highlighted ? root.design.selectedText : root.design.primaryText

    background: DelegateBackground {
        control: root
        design: root.design
    }

    contentItem: RowLayout {
        spacing: Kirigami.Units.smallSpacing

        NavigationIcon {
            iconName: root.navigationIconName(root.model.decoration)
        }

        PlasmaComponents.Label {
            Layout.fillWidth: true
            color: root.highlighted ? root.design.selectedText : root.design.primaryText
            elide: Text.ElideRight
            text: root.text
            verticalAlignment: Text.AlignVCenter
        }
    }

    Accessible.description: i18n("Show applications in %1", root.model.display)

    onClicked: {
        ListView.view.currentIndex = root.index;
        root.activated(root.index);
    }

    Accessible.onPressAction: root.clicked()
}
