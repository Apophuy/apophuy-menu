/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Dialogs as Dialogs
import QtQuick.Layouts
import org.kde.kcmutils as KCMUtils
import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid

KCMUtils.SimpleKCM {
    id: root

    property alias cfg_themeMode: themeMode.currentIndex
    property alias cfg_launcherIcon: launcherIcon.currentIndex
    property alias cfg_iconColorPreset: iconColorPreset.currentIndex
    property color cfg_iconCustomColor: "#39d641"

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        QQC2.ComboBox {
            id: themeMode

            Kirigami.FormData.label: i18n("Theme:")
            model: [i18n("Follow system"), i18n("Light"), i18n("Dark")]
        }

        QQC2.ComboBox {
            id: launcherIcon

            Kirigami.FormData.label: i18n("Panel icon:")
            model: [i18n("Apophuy Penguin"), i18n("Flat Penguin"), i18n("System launcher icon")]
        }

        QQC2.ComboBox {
            id: iconColorPreset

            Kirigami.FormData.label: i18n("Penguin color:")
            enabled: launcherIcon.currentIndex !== 2
            model: [
                i18n("Original palette"),
                i18n("Ocean"),
                i18n("Amber"),
                i18n("Violet"),
                i18n("Custom")
            ]
        }

        RowLayout {
            visible: launcherIcon.currentIndex !== 2 && iconColorPreset.currentIndex === 4
            Kirigami.FormData.label: i18n("Custom color:")

            Rectangle {
                Layout.preferredHeight: Kirigami.Units.gridUnit * 1.5
                Layout.preferredWidth: Layout.preferredHeight

                border.color: Kirigami.Theme.disabledTextColor
                color: root.cfg_iconCustomColor
                radius: Kirigami.Units.smallSpacing
            }

            QQC2.Button {
                text: i18n("Choose custom color…")
                icon.name: "color-picker"
                onClicked: {
                    colorDialog.selectedColor = root.cfg_iconCustomColor;
                    colorDialog.open();
                }
            }
        }
    }

    Dialogs.ColorDialog {
        id: colorDialog

        title: i18n("Choose penguin color")
        onAccepted: {
            root.cfg_iconCustomColor = selectedColor;
            iconColorPreset.currentIndex = 4;
        }
    }
}
