/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.private.kicker as Kicker
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: root

    width: Kirigami.Units.iconSizes.huge
    height: Kirigami.Units.iconSizes.huge

    hideOnWindowDeactivate: true
    preferredRepresentation: compactRepresentation
    toolTipMainText: i18n("Apophuy Application Launcher")
    toolTipSubText: i18n("Open the application launcher")

    Plasmoid.icon: "start-here-kde"

    readonly property Kicker.RootModel applicationsRootModel: Kicker.RootModel {
        autoPopulate: false
        appletInterface: root
        flat: true
        sorted: true
        showSeparators: false
        showTopLevelItems: true
        showAllApps: true
        showAllAppsCategorized: false
        showRecentApps: false
        showRecentDocs: false
        showPowerSession: false
        showFavoritesPlaceholder: false

        Component.onCompleted: {
            favoritesModel.initForClient("io.github.apophuy.applicationlauncher.favorites.instance-" + Plasmoid.id);
        }
    }

    compactRepresentation: CompactRepresentation {
        appletRoot: root
    }

    fullRepresentation: FullRepresentation {
        appletRoot: root
        rootModel: root.applicationsRootModel
    }

    Component.onCompleted: {
        Plasmoid.activationTogglesExpanded = true;
    }
}
