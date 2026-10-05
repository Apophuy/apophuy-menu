/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import org.kde.plasma.configuration as PlasmaConfig

PlasmaConfig.ConfigModel {
    PlasmaConfig.ConfigCategory {
        icon: "preferences-desktop-color"
        name: i18n("Appearance")
        source: "ConfigAppearance.qml"
    }
}
