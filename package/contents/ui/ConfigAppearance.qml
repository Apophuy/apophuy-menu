/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kcmutils as KCMUtils
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

KCMUtils.SimpleKCM {
    id: root

    property alias cfg_themeMode: themeMode.currentIndex

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        QQC2.ComboBox {
            id: themeMode

            Kirigami.FormData.label: i18n("Theme:")
            model: [i18n("Follow system"), i18n("Light"), i18n("Dark")]
        }
    }
}
