/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid

FocusScope {
    id: root

    required property PlasmoidItem appletRoot
    required property var rootModel

    property var applicationModel: null
    property bool showingFavorites: false

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

        root.showingFavorites = false;
        categoryList.currentIndex = row;
        root.applicationModel = root.rootModel.modelForRow(row);
    }

    function showFavorites(): void {
        root.showingFavorites = true;
        categoryList.currentIndex = -1;
        root.applicationModel = root.rootModel.favoritesModel;
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        ColumnLayout {
            Layout.fillHeight: true
            Layout.preferredWidth: Kirigami.Units.gridUnit * 10
            spacing: 0

            PlasmaComponents.ItemDelegate {
                id: favoritesButton

                Layout.fillWidth: true

                Accessible.description: i18n("Show favorite applications")
                focus: root.showingFavorites
                highlighted: root.showingFavorites
                icon.name: "bookmarks"
                KeyNavigation.right: applicationList
                text: i18n("Favorites")

                onClicked: {
                    root.showFavorites();
                    applicationList.forceActiveFocus(Qt.TabFocusReason);
                }
            }

            Kirigami.Separator {
                Layout.fillWidth: true
            }

            CategoryList {
                id: categoryList

                Layout.fillWidth: true
                Layout.fillHeight: true

                categoryModel: root.rootModel
                focus: !root.showingFavorites
                KeyNavigation.right: applicationList

                onCategoryActivated: row => {
                    root.selectCategory(row);
                    applicationList.forceActiveFocus(Qt.TabFocusReason);
                }
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
            emptyText: root.showingFavorites ? i18n("No favorite applications") : i18n("No applications in this category")
            favoritesModel: root.rootModel.favoritesModel
            KeyNavigation.left: root.showingFavorites ? favoritesButton : categoryList
        }
    }

    Connections {
        target: root.rootModel

        function onRefreshed(): void {
            if (root.showingFavorites) {
                root.showFavorites();
                return;
            }

            const selectedRow = Math.max(0, categoryList.currentIndex);
            root.selectCategory(Math.min(selectedRow, root.rootModel.count - 1));
        }
    }

    Component.onCompleted: {
        root.rootModel.refresh();
        if (root.rootModel.favoritesModel.count > 0) {
            root.showFavorites();
        } else {
            root.selectCategory(0);
        }
    }
}
