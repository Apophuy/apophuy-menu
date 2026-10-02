/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

PlasmaComponents.ItemDelegate {
    id: root

    required property int index
    required property var model
    required property var applicationModel
    required property var appletRoot
    required property var favoritesModel

    readonly property string favoriteId: root.model.favoriteId !== undefined && root.model.favoriteId !== null ? root.model.favoriteId : ""
    readonly property bool isFavorite: {
        const favoriteCount = root.favoritesModel ? root.favoritesModel.count : 0;
        return favoriteCount >= 0 && root.favoriteId !== "" && root.favoritesModel.isFavorite(root.favoriteId);
    }

    width: ListView.view.width
    enabled: !root.model.disabled
    highlighted: ListView.isCurrentItem
    icon.name: root.model.decoration || "application-x-executable"
    rightPadding: favoriteButton.visible ? favoriteButton.width + Kirigami.Units.smallSpacing : undefined
    text: root.model.compactName || root.model.display

    Accessible.description: root.model.description || root.model.display

    function trigger(): void {
        ListView.view.currentIndex = root.index;
        if (root.applicationModel.trigger(root.index, "", null)) {
            root.appletRoot.expanded = false;
        }
    }

    onClicked: root.trigger()
    Accessible.onPressAction: root.trigger()

    PlasmaComponents.ToolButton {
        id: favoriteButton

        anchors.right: parent.right
        anchors.rightMargin: Kirigami.Units.smallSpacing
        anchors.verticalCenter: parent.verticalCenter

        Accessible.name: root.isFavorite ? i18n("Remove %1 from Favorites", root.text) : i18n("Add %1 to Favorites", root.text)
        display: PlasmaComponents.AbstractButton.IconOnly
        enabled: root.favoritesModel && root.favoritesModel.enabled
        icon.name: root.isFavorite ? "bookmark-remove" : "bookmark-new"
        visible: root.favoriteId !== ""

        PlasmaComponents.ToolTip.text: favoriteButton.Accessible.name
        PlasmaComponents.ToolTip.visible: favoriteButton.hovered

        onClicked: {
            if (root.isFavorite) {
                root.favoritesModel.removeFavorite(root.favoriteId);
            } else {
                root.favoritesModel.addFavorite(root.favoriteId);
            }
        }
    }
}
