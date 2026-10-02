/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

FocusScope {
    id: root

    required property PlasmoidItem appletRoot
    required property var rootModel

    property var applicationModel: null

    implicitWidth: Kirigami.Units.gridUnit * 22
    implicitHeight: Kirigami.Units.gridUnit * 26

    Layout.minimumWidth: Kirigami.Units.gridUnit * 16
    Layout.minimumHeight: Kirigami.Units.gridUnit * 18
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight

    activeFocusOnTab: true
    focus: true

    Keys.onEscapePressed: event => {
        root.appletRoot.expanded = false;
        event.accepted = true;
    }

    function selectCategory(row: int): void {
        if (row < 0 || row >= root.rootModel.count) {
            root.applicationModel = null;
            return;
        }

        categoryList.currentIndex = row;
        root.applicationModel = root.rootModel.modelForRow(row);
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        CategoryList {
            id: categoryList

            Layout.fillHeight: true
            Layout.preferredWidth: Kirigami.Units.gridUnit * 10

            categoryModel: root.rootModel
            focus: true
            KeyNavigation.right: applicationList

            onCategoryActivated: row => {
                root.selectCategory(row);
                applicationList.forceActiveFocus(Qt.TabFocusReason);
            }
        }

        Kirigami.Separator {
            Layout.fillHeight: true
        }

        ApplicationList {
            id: applicationList

            Layout.fillWidth: true
            Layout.fillHeight: true

            applicationModel: root.applicationModel
            appletRoot: root.appletRoot
            KeyNavigation.left: categoryList
        }
    }

    Connections {
        target: root.rootModel

        function onRefreshed(): void {
            const selectedRow = Math.max(0, categoryList.currentIndex);
            root.selectCategory(Math.min(selectedRow, root.rootModel.count - 1));
        }
    }

    Component.onCompleted: {
        root.rootModel.refresh();
        root.selectCategory(0);
    }
}
