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
    required property var runnerModel
    required property var systemModel

    property var applicationModel: null
    property bool showingFavorites: false
    property var searchResultsModel: null

    readonly property bool searching: searchField.text.length > 0

    implicitWidth: Kirigami.Units.gridUnit * 22
    implicitHeight: Kirigami.Units.gridUnit * 26

    Layout.minimumWidth: Kirigami.Units.gridUnit * 16
    Layout.minimumHeight: Kirigami.Units.gridUnit * 18
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight

    activeFocusOnTab: true
    focus: true

    Keys.onEscapePressed: event => {
        root.handleEscape();
        event.accepted = true;
    }

    function handleEscape(): void {
        if (root.searching) {
            searchField.clear();
            searchField.forceActiveFocus(Qt.ShortcutFocusReason);
        } else {
            root.appletRoot.expanded = false;
        }
    }

    function selectCategory(row: int): void {
        if (row < 0 || row >= root.rootModel.count) {
            root.applicationModel = null;
            return;
        }

        root.showingFavorites = false;
        searchField.clear();
        categoryList.currentIndex = row;
        root.applicationModel = root.rootModel.modelForRow(row);
    }

    function showFavorites(): void {
        root.showingFavorites = true;
        searchField.clear();
        categoryList.currentIndex = -1;
        root.applicationModel = root.rootModel.favoritesModel;
    }

    function updateSearchResults(): void {
        root.searchResultsModel = root.runnerModel.count > 0 ? root.runnerModel.modelForRow(0) : null;
        applicationList.currentIndex = root.searchResultsModel && root.searchResultsModel.count > 0 ? 0 : -1;
    }

    function triggerFirstSearchResult(): void {
        if (!root.searchResultsModel || root.searchResultsModel.count < 1) {
            return;
        }

        if (root.searchResultsModel.trigger(0, "", null)) {
            root.appletRoot.expanded = false;
        }
    }

    function focusSearchField(): void {
        Qt.callLater(() => {
            if (root.appletRoot.expanded) {
                searchField.forceActiveFocus(Qt.PopupFocusReason);
                searchField.selectAll();
            }
        });
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Kirigami.Units.smallSpacing

        SearchField {
            id: searchField

            Layout.fillWidth: true
            Layout.leftMargin: Kirigami.Units.smallSpacing
            Layout.rightMargin: Kirigami.Units.smallSpacing
            Layout.topMargin: Kirigami.Units.smallSpacing

            onAccepted: root.triggerFirstSearchResult()
            onDownRequested: {
                if (applicationList.count > 0) {
                    applicationList.forceActiveFocus(Qt.TabFocusReason);
                }
            }
            onEscapeRequested: root.handleEscape()
            onQueryEdited: query => {
                root.runnerModel.query = query;
                if (query.length === 0) {
                    root.searchResultsModel = null;
                } else {
                    root.updateSearchResults();
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            ColumnLayout {
                Layout.fillHeight: true
                Layout.preferredWidth: Kirigami.Units.gridUnit * 10
                enabled: !root.searching
                opacity: enabled ? 1 : 0.6
                spacing: 0

                PlasmaComponents.ItemDelegate {
                    id: favoritesButton

                    Layout.fillWidth: true

                    Accessible.description: i18n("Show favorite applications")
                    focus: root.showingFavorites && !root.searching
                    highlighted: root.showingFavorites && !root.searching
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
                    focus: !root.showingFavorites && !root.searching
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

                applicationModel: root.searching ? root.searchResultsModel : root.applicationModel
                appletRoot: root.appletRoot
                emptyText: root.searching ? i18n("No search results") : (root.showingFavorites ? i18n("No favorite applications") : i18n("No applications in this category"))
                favoritesModel: root.rootModel.favoritesModel
                KeyNavigation.left: root.searching ? searchField : (root.showingFavorites ? favoritesButton : categoryList)
            }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
        }

        SystemActions {
            Layout.fillWidth: true
            Layout.leftMargin: Kirigami.Units.smallSpacing
            Layout.rightMargin: Kirigami.Units.smallSpacing
            Layout.bottomMargin: Kirigami.Units.smallSpacing

            appletRoot: root.appletRoot
            systemModel: root.systemModel
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

    Connections {
        target: root.runnerModel

        function onCountChanged(): void {
            root.updateSearchResults();
        }

        function onQueryFinished(): void {
            root.updateSearchResults();
        }

        function onRequestUpdateQuery(query): void {
            searchField.text = query;
        }
    }

    Connections {
        target: root.appletRoot

        function onExpandedChanged(): void {
            if (root.appletRoot.expanded) {
                root.focusSearchField();
            } else {
                searchField.clear();
                root.searchResultsModel = null;
            }
        }
    }

    Component.onCompleted: {
        root.rootModel.refresh();
        if (root.rootModel.favoritesModel.count > 0) {
            root.showFavorites();
        } else {
            root.selectCategory(0);
        }
        if (root.appletRoot.expanded) {
            root.focusSearchField();
        }
    }
}
