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

    readonly property color penguinAccentColor: {
        switch (Plasmoid.configuration.iconColorPreset) {
        case 1:
            return "#2586c7";
        case 2:
            return "#d88919";
        case 3:
            return "#805bd4";
        case 4:
            return Plasmoid.configuration.iconCustomColor;
        default:
            return "#39d641";
        }
    }

    readonly property bool penguinUsesOriginalColor: Plasmoid.configuration.iconColorPreset === 0

    Plasmoid.icon: Plasmoid.configuration.launcherIcon === 0
                   ? Qt.resolvedUrl("../images/launcher/penguin.png")
                   : "start-here-kde"

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

    readonly property Kicker.RunnerModel runnerModel: Kicker.RunnerModel {
        appletInterface: root
        favoritesModel: root.applicationsRootModel.favoritesModel
        mergeResults: true
    }

    readonly property Kicker.SystemModel systemModel: Kicker.SystemModel {}

    SystemPalette {
        id: systemPalette
    }

    compactRepresentation: CompactRepresentation {
        appletRoot: root
        launcherIcon: Plasmoid.configuration.launcherIcon
        penguinAccentColor: root.penguinAccentColor
        penguinUsesOriginalColor: root.penguinUsesOriginalColor
    }

    fullRepresentation: FullRepresentation {
        appletRoot: root
        rootModel: root.applicationsRootModel
        runnerModel: root.runnerModel
        systemPalette: systemPalette
        systemModel: root.systemModel
        themeMode: Plasmoid.configuration.themeMode
    }

    Component.onCompleted: {
        Plasmoid.activationTogglesExpanded = true;
    }
}
