/*
    SPDX-FileCopyrightText: 2026 Apophuy
    SPDX-License-Identifier: GPL-3.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtTest
import org.kde.plasma.private.kicker as Kicker

TestCase {
    id: testCase

    name: "RunnerModel"

    Kicker.RunnerModel {
        id: runnerModel

        mergeResults: true
        runners: ["krunner_services"]
    }

    function test_applicationQuery(): void {
        runnerModel.query = "KCalc";

        tryVerify(() => runnerModel.count > 0, 10000);
        tryVerify(() => runnerModel.modelForRow(0).count > 0, 10000);

        runnerModel.query = "";
    }
}
