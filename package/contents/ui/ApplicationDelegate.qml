/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
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
    required property var applicationModel
    required property var appletRoot
    required property var design
    required property var favoritesModel

    readonly property string favoriteId: root.model.favoriteId !== undefined && root.model.favoriteId !== null ? root.model.favoriteId : ""
    readonly property bool isFavorite: {
        const favoriteCount = root.favoritesModel ? root.favoritesModel.count : 0;
        return favoriteCount >= 0 && root.favoriteId !== "" && root.favoritesModel.isFavorite(root.favoriteId);
    }

    enabled: !root.model.disabled
    highlighted: GridView.isCurrentItem
    icon.name: root.model.decoration || "application-x-executable"
    padding: 0
    text: root.model.compactName || root.model.display

    Kirigami.Theme.highlightedTextColor: root.design.selectedText
    Kirigami.Theme.textColor: root.highlighted ? root.design.selectedText : root.design.primaryText

    background: DelegateBackground {
        control: root
        design: root.design
    }

    Accessible.description: root.model.description || root.model.display

    contentItem: Item {
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.smallSpacing
            spacing: Kirigami.Units.smallSpacing

            Kirigami.Icon {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: Kirigami.Units.iconSizes.large
                Layout.preferredWidth: Kirigami.Units.iconSizes.large
                source: root.model.decoration || "application-x-executable"
            }

            PlasmaComponents.Label {
                Layout.fillWidth: true
                Layout.maximumHeight: implicitHeight * 2

                color: root.highlighted ? root.design.selectedText : root.design.primaryText
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                maximumLineCount: 2
                text: root.text
                verticalAlignment: Text.AlignTop
                wrapMode: Text.Wrap
            }
        }
    }

    function trigger(): void {
        GridView.view.currentIndex = root.index;
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
        anchors.top: parent.top
        anchors.topMargin: Kirigami.Units.smallSpacing

        Accessible.name: root.isFavorite ? i18n("Remove %1 from Favorites", root.text) : i18n("Add %1 to Favorites", root.text)
        display: PlasmaComponents.AbstractButton.IconOnly
        enabled: root.favoritesModel && root.favoritesModel.enabled
        icon.name: root.isFavorite ? "bookmark-remove" : "bookmark-new"
        opacity: favoriteButton.hovered || favoriteButton.activeFocus ? 1 : 0.62
        visible: root.favoriteId !== "" && (root.isFavorite || root.hovered || root.activeFocus)

        background: DelegateBackground {
            control: favoriteButton
            design: root.design
        }

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
