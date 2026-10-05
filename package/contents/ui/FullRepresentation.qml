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
    required property var systemPalette
    required property var systemModel
    required property int themeMode

    property var applicationModel: null
    property bool showingFavorites: false
    property var searchResultsModel: null

    readonly property bool searching: searchField.text.length > 0
    readonly property real headerHeight: Kirigami.Units.gridUnit * 2.7
    readonly property real sidebarWidth: Kirigami.Units.gridUnit * 10 + 4

    implicitWidth: Kirigami.Units.gridUnit * 34
    implicitHeight: Kirigami.Units.gridUnit * 34

    Layout.minimumWidth: implicitWidth
    Layout.minimumHeight: implicitHeight
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight

    activeFocusOnTab: true
    focus: true

    Kirigami.Theme.backgroundColor: design.background
    Kirigami.Theme.disabledTextColor: design.secondaryText
    Kirigami.Theme.focusColor: design.focus
    Kirigami.Theme.highlightColor: design.selected
    Kirigami.Theme.highlightedTextColor: design.selectedText
    Kirigami.Theme.hoverColor: design.hover
    Kirigami.Theme.inherit: false
    Kirigami.Theme.negativeTextColor: design.destructive
    Kirigami.Theme.neutralTextColor: design.warning
    Kirigami.Theme.positiveTextColor: design.success
    Kirigami.Theme.textColor: design.primaryText

    DesignTokens {
        id: design

        systemBackground: root.systemPalette && root.systemPalette.background !== undefined ? root.systemPalette.background : "#20252d"
        systemHighlight: root.systemPalette && root.systemPalette.highlight !== undefined ? root.systemPalette.highlight : "#3f88c5"
        systemHighlightedText: root.systemPalette && root.systemPalette.highlightedText !== undefined ? root.systemPalette.highlightedText : "#ffffff"
        systemNegative: root.systemPalette && root.systemPalette.negative !== undefined ? root.systemPalette.negative : "#e35d6a"
        systemNeutral: root.systemPalette && root.systemPalette.neutral !== undefined ? root.systemPalette.neutral : "#e7a13d"
        systemPositive: root.systemPalette && root.systemPalette.positive !== undefined ? root.systemPalette.positive : "#55b879"
        systemText: root.systemPalette && root.systemPalette.text !== undefined ? root.systemPalette.text : "#f4f6f8"
        themeMode: root.themeMode
    }

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

    Rectangle {
        anchors.fill: parent
        color: design.background
        radius: Kirigami.Units.cornerRadius
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing
        spacing: Kirigami.Units.largeSpacing

        RowLayout {
            Layout.fillWidth: true
            Layout.maximumHeight: root.headerHeight
            Layout.minimumHeight: root.headerHeight
            Layout.preferredHeight: root.headerHeight
            spacing: Kirigami.Units.largeSpacing

            Rectangle {
                Layout.fillHeight: true
                Layout.maximumWidth: root.sidebarWidth
                Layout.minimumWidth: root.sidebarWidth
                Layout.preferredWidth: root.sidebarWidth
                border.color: design.border
                border.width: 1
                color: design.elevatedBackground
                radius: Kirigami.Units.cornerRadius

                SystemActions {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.smallSpacing

                    appletRoot: root.appletRoot
                    design: design
                    systemModel: root.systemModel
                }
            }

            SearchField {
                id: searchField

                Layout.fillHeight: true
                Layout.fillWidth: true
                design: design
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
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Kirigami.Units.largeSpacing

            Rectangle {
                Layout.fillHeight: true
                Layout.maximumWidth: root.sidebarWidth
                Layout.minimumWidth: root.sidebarWidth
                Layout.preferredWidth: root.sidebarWidth
                border.color: design.border
                border.width: 1
                color: design.elevatedBackground
                enabled: !root.searching
                opacity: enabled ? 1 : 0.6
                radius: Kirigami.Units.cornerRadius

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.smallSpacing
                    spacing: Kirigami.Units.smallSpacing

                    PlasmaComponents.ItemDelegate {
                        id: favoritesButton

                        Layout.fillWidth: true
                        Layout.preferredHeight: Kirigami.Units.gridUnit * 2.1

                        bottomPadding: Math.round(Kirigami.Units.smallSpacing / 2)
                        leftPadding: Kirigami.Units.largeSpacing
                        rightPadding: Kirigami.Units.largeSpacing
                        topPadding: Math.round(Kirigami.Units.smallSpacing / 2)

                        Accessible.description: i18n("Show favorite applications")
                        focus: root.showingFavorites && !root.searching
                        highlighted: root.showingFavorites && !root.searching
                        icon.name: "bookmarks"
                        KeyNavigation.right: applicationList
                        text: i18n("Favorites")

                        background: DelegateBackground {
                            control: favoritesButton
                            design: design
                        }

                        onClicked: {
                            root.showFavorites();
                            applicationList.forceActiveFocus(Qt.TabFocusReason);
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color: design.border
                    }

                    CategoryList {
                        id: categoryList

                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        categoryModel: root.rootModel
                        design: design
                        focus: !root.showingFavorites && !root.searching
                        KeyNavigation.right: applicationList

                        onCategoryActivated: row => {
                            root.selectCategory(row);
                            applicationList.forceActiveFocus(Qt.TabFocusReason);
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                border.color: design.border
                border.width: 1
                color: design.elevatedBackground
                radius: Kirigami.Units.cornerRadius

                ApplicationList {
                    id: applicationList

                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.smallSpacing

                    applicationModel: root.searching ? root.searchResultsModel : root.applicationModel
                    appletRoot: root.appletRoot
                    design: design
                    emptyText: root.searching ? i18n("No search results") : (root.showingFavorites ? i18n("No favorite applications") : i18n("No applications in this category"))
                    favoritesModel: root.rootModel.favoritesModel
                    KeyNavigation.left: root.searching ? searchField : (root.showingFavorites ? favoritesButton : categoryList)
                }
            }
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
