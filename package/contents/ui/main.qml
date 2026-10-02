/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

PlasmoidItem {
    id: root

    width: Kirigami.Units.iconSizes.huge
    height: Kirigami.Units.iconSizes.huge

    hideOnWindowDeactivate: true
    preferredRepresentation: compactRepresentation
    toolTipMainText: i18n("Apophuy Menu")
    toolTipSubText: i18n("Open the application launcher")

    Plasmoid.icon: "start-here-kde"

    compactRepresentation: CompactRepresentation {
        appletRoot: root
    }

    fullRepresentation: FullRepresentation {
        appletRoot: root
    }

    Component.onCompleted: {
        Plasmoid.activationTogglesExpanded = true;
    }
}
