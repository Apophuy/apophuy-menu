/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kitemmodels as KItemModels
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras

RowLayout {
    id: root

    required property var appletRoot
    required property var design
    required property var systemModel

    spacing: Kirigami.Units.smallSpacing

    function isSessionAction(actionId: string): bool {
        return ["lock-screen", "logout", "save-session", "switch-user"].includes(actionId);
    }

    function triggerAction(row: int): void {
        if (root.systemModel.trigger(row, "", null)) {
            root.appletRoot.expanded = false;
        }
    }

    component FilteredSystemModel: KItemModels.KSortFilterProxyModel {
        required property bool sessionActions

        sourceModel: root.systemModel
        filterRowCallback: (sourceRow, sourceParent) => {
            const favoriteIdRole = sourceModel.KItemModels.KRoleNames.role("favoriteId");
            const favoriteId = sourceModel.data(sourceModel.index(sourceRow, 0, sourceParent), favoriteIdRole);
            return root.isSessionAction(favoriteId) === sessionActions;
        }

        function trigger(row: int): void {
            const sourceIndex = mapToSource(index(row, 0));
            root.triggerAction(sourceIndex.row);
        }
    }

    FilteredSystemModel {
        id: sessionActionsModel

        sessionActions: true
    }

    FilteredSystemModel {
        id: powerActionsModel

        sessionActions: false
    }

    PlasmaComponents.Button {
        id: sessionButton

        Layout.fillHeight: true
        Layout.fillWidth: true

        Accessible.name: text
        Accessible.role: Accessible.ButtonMenu
        down: sessionMenu.status === PlasmaExtras.Menu.Open || pressed
        focusPolicy: Qt.StrongFocus
        text: i18n("Session")

        background: DelegateBackground {
            control: sessionButton
            design: root.design
        }

        contentItem: RowLayout {
            spacing: Kirigami.Units.smallSpacing

            SystemActionTile {
                Layout.alignment: Qt.AlignVCenter

                actionId: "lock-screen"
                design: root.design
                iconSource: "system-lock-screen"
                pressed: sessionButton.down
                size: Kirigami.Units.iconSizes.smallMedium
            }

            PlasmaComponents.Label {
                Layout.fillWidth: true

                color: sessionButton.down ? root.design.selectedText : root.design.primaryText
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                text: sessionButton.text
                verticalAlignment: Text.AlignVCenter
            }
        }

        onClicked: sessionMenu.open()
    }

    PlasmaComponents.Button {
        id: powerButton

        Layout.fillHeight: true
        Layout.fillWidth: true

        Accessible.name: text
        Accessible.role: Accessible.ButtonMenu
        down: powerMenu.status === PlasmaExtras.Menu.Open || pressed
        focusPolicy: Qt.StrongFocus
        text: i18n("Power")

        background: DelegateBackground {
            control: powerButton
            design: root.design
        }

        contentItem: RowLayout {
            spacing: Kirigami.Units.smallSpacing

            SystemActionTile {
                Layout.alignment: Qt.AlignVCenter

                actionId: "shutdown"
                design: root.design
                iconSource: "system-shutdown"
                pressed: powerButton.down
                size: Kirigami.Units.iconSizes.smallMedium
            }

            PlasmaComponents.Label {
                Layout.fillWidth: true

                color: powerButton.down ? root.design.selectedText : root.design.primaryText
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                text: powerButton.text
                verticalAlignment: Text.AlignVCenter
            }
        }

        onClicked: powerMenu.open()
    }

    Instantiator {
        model: sessionActionsModel

        delegate: PlasmaExtras.MenuItem {
            required property int index
            required property var model

            enabled: !model.disabled
            icon: model.decoration
            text: model.display

            onClicked: sessionActionsModel.trigger(index)
        }

        onObjectAdded: (index, object) => sessionMenu.addMenuItem(object)
        onObjectRemoved: (index, object) => sessionMenu.removeMenuItem(object)
    }

    Instantiator {
        model: powerActionsModel

        delegate: PlasmaExtras.MenuItem {
            required property int index
            required property var model

            enabled: !model.disabled
            icon: model.decoration
            text: model.display

            onClicked: powerActionsModel.trigger(index)
        }

        onObjectAdded: (index, object) => powerMenu.addMenuItem(object)
        onObjectRemoved: (index, object) => powerMenu.removeMenuItem(object)
    }

    PlasmaExtras.Menu {
        id: sessionMenu

        visualParent: sessionButton
    }

    PlasmaExtras.Menu {
        id: powerMenu

        visualParent: powerButton
    }
}
