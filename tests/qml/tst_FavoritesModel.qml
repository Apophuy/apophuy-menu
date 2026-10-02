/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtTest
import org.kde.plasma.private.kicker as Kicker

TestCase {
    id: testCase

    readonly property string clientId: "io.github.apophuy.applicationlauncher.tests.favorites"
    readonly property string testApplicationId: "org.kde.kcalc.desktop"

    name: "FavoritesModel"

    Kicker.RootModel {
        id: rootModel

        autoPopulate: false
        flat: true
        showAllApps: true
        showPowerSession: false
        showRecentApps: false
        showRecentDocs: false

        Component.onCompleted: favoritesModel.initForClient(testCase.clientId)
    }

    function initTestCase(): void {
        rootModel.refresh();
        tryVerify(() => rootModel.favoritesModel.enabled, 5000);
        rootModel.favoritesModel.removeFavorite(testCase.testApplicationId);
        tryVerify(() => !rootModel.favoritesModel.isFavorite(testCase.testApplicationId), 5000);
    }

    function test_addRefreshRemove(): void {
        rootModel.favoritesModel.addFavorite(testCase.testApplicationId);
        tryVerify(() => rootModel.favoritesModel.isFavorite(testCase.testApplicationId), 5000);

        rootModel.refresh();
        tryVerify(() => rootModel.favoritesModel.isFavorite(testCase.testApplicationId), 5000);

        rootModel.favoritesModel.removeFavorite(testCase.testApplicationId);
        tryVerify(() => !rootModel.favoritesModel.isFavorite(testCase.testApplicationId), 5000);
    }

    function cleanupTestCase(): void {
        rootModel.favoritesModel.removeFavorite(testCase.testApplicationId);
    }
}
