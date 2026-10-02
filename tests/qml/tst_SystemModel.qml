/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtTest
import org.kde.kitemmodels as KItemModels
import org.kde.plasma.private.kicker as Kicker

TestCase {
    id: testCase

    name: "SystemModel"

    Kicker.SystemModel {
        id: systemModel
    }

    function test_onlyAvailableActionsAreExposed(): void {
        verify(systemModel.count > 0);
        verify(systemModel.count <= 8);

        const disabledRole = systemModel.KItemModels.KRoleNames.role("disabled");
        for (let row = 0; row < systemModel.count; ++row) {
            const modelIndex = systemModel.index(row, 0);
            compare(systemModel.data(modelIndex, disabledRole), false);
        }
    }
}
