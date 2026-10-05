/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtTest
import "../../package/contents/ui" as Apophuy

TestCase {
    id: testCase

    name: "DesignTokens"

    function relativeLuminance(value: color): real {
        function channel(component) {
            return component <= 0.04045 ? component / 12.92 : Math.pow((component + 0.055) / 1.055, 2.4);
        }

        return 0.2126 * channel(value.r) + 0.7152 * channel(value.g) + 0.0722 * channel(value.b);
    }

    function contrast(first: color, second: color): real {
        const lighter = Math.max(relativeLuminance(first), relativeLuminance(second));
        const darker = Math.min(relativeLuminance(first), relativeLuminance(second));
        return (lighter + 0.05) / (darker + 0.05);
    }

    function test_explicitThemesAreDeterministic(): void {
        compare(lightTokens.background.toString(), "#f6f8fb");
        compare(darkTokens.background.toString(), "#1b2028");
        verify(!lightTokens.dark);
        verify(darkTokens.dark);
    }

    function test_systemThemeUsesHostPalette(): void {
        compare(systemTokens.background.toString(), "#20252d");
        compare(systemTokens.primaryText.toString(), "#f4f6f8");
        compare(systemTokens.accent.toString(), "#3f88c5");
        verify(systemTokens.dark);
        verify(contrast(systemTokens.selectedText, systemTokens.selected) >= 4.5);
    }

    function test_actionTilesKeepWhiteGlyphContrast(): void {
        const actionIds = ["lock-screen", "logout", "suspend", "hibernate", "reboot", "shutdown", "switch-user", "save-session"];
        for (const actionId of actionIds) {
            verify(contrast(lightTokens.actionColor(actionId), "#ffffff") >= 4.5, actionId + " action color does not meet text contrast");
        }
    }

    function test_explicitThemeTextContrast(): void {
        const themes = [lightTokens, darkTokens];
        for (const theme of themes) {
            verify(contrast(theme.primaryText, theme.background) >= 7.0, "primary text contrast is below 7:1");
            verify(contrast(theme.secondaryText, theme.background) >= 4.5, "secondary text contrast is below 4.5:1");
            verify(contrast(theme.selectedText, theme.selected) >= 4.5, "selected text contrast is below 4.5:1");
        }
    }

    function test_favoriteTokenIsVisibleAndDistinct(): void {
        compare(lightTokens.favorite.toString(), "#a86d00");
        compare(darkTokens.favorite.toString(), "#f6c744");
        verify(contrast(lightTokens.favorite, lightTokens.background) >= 3.0);
        verify(contrast(darkTokens.favorite, darkTokens.background) >= 3.0);
        verify(lightTokens.favorite.toString() !== lightTokens.secondaryText.toString());
        verify(darkTokens.favorite.toString() !== darkTokens.secondaryText.toString());
    }

    Apophuy.DesignTokens {
        id: systemTokens

        systemBackground: "#20252d"
        systemHighlight: "#3f88c5"
        systemHighlightedText: "#ffffff"
        systemNegative: "#e35d6a"
        systemNeutral: "#e7a13d"
        systemPositive: "#55b879"
        systemText: "#f4f6f8"
        themeMode: 0
    }

    Apophuy.DesignTokens {
        id: lightTokens

        systemBackground: "#ffffff"
        systemHighlight: "#3f88c5"
        systemHighlightedText: "#ffffff"
        systemNegative: "#b5333c"
        systemNeutral: "#9a5700"
        systemPositive: "#2f7d4a"
        systemText: "#1b2027"
        themeMode: 1
    }

    Apophuy.DesignTokens {
        id: darkTokens

        systemBackground: "#ffffff"
        systemHighlight: "#3f88c5"
        systemHighlightedText: "#ffffff"
        systemNegative: "#b5333c"
        systemNeutral: "#9a5700"
        systemPositive: "#2f7d4a"
        systemText: "#1b2027"
        themeMode: 2
    }
}
