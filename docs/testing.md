# Testing strategy

## Test layers

1. Static checks: package metadata, QML syntax/type lint, formatting check, shell syntax, translation extraction/compilation.
2. Windowed smoke test: load and interact through `plasmawindowed` and, once installed, `plasmoidviewer` in horizontal/vertical and HiDPI modes.
3. Real integration test: install to the user plasmoid directory and add to an actual Plasma panel on Wayland.
4. Regression/stress test: repeat lifecycle, focus, launch, session, panel, display, and suspend scenarios.

Windowed smoke tests do not replace panel testing. In Plasma 6.3.6, `plasmawindowed` disables `hideOnWindowDeactivate`, so it cannot validate outside-click closure.

Standalone `qmllint` cannot resolve Plasma's context-provided plasmoid module in this Debian installation. Its import/type/context warnings must be reviewed against `docs/development-environment.md`; parser errors and warnings from resolvable Qt/KF modules still fail the check. A Plasma-host load is mandatory alongside linting.

## Popup state contract

| Initial state | Event | Expected state | Required observation |
| --- | --- | --- | --- |
| closed | click compact representation | open | one popup, full representation focused |
| open | click the same compact representation | closed | no stale visible popup; `expanded == false` |
| open | click desktop/another normal window | closed | closes without a second launcher click |
| open | activate another plasmoid | closed | only the newly activated popup remains |
| open | Escape | closed | search/focus reset for next opening |
| open | successful application launch | closed | application starts once |
| open | successful search-result launch | closed | result starts once |
| open | available system action | closed when appropriate | action is invoked once |
| open | open a child context menu | open | parent must not close while the transient child owns focus |
| open | dismiss child context menu outside launcher | closed or returns to parent according to native Plasma behavior | no orphan popup |
| open | switch virtual desktop/activity | closed if native Plasma closes peer launchers | state and visuals agree |
| open | panel is removed/recreated | destroyed/closed | no orphan window or stale state |

## Milestone 1 acceptance run

The minimal plasmoid is not accepted until all of the following pass on Wayland:

- 100 deliberate open/close cycles;
- 100 fast alternating clicks;
- 20 cycles each of open then desktop click, Escape, application launch, and another-plasmoid activation;
- horizontal bottom/top and vertical left/right panels;
- no critical QML warnings, crashes, duplicate launches, or state disagreement between `expanded` and popup visibility.

Record the Plasma/libplasma versions, panel location, scale factor, display count, exact steps, and result. A popup/focus bug fix must add the reproducer to the state table before changing code.

## Development commands

Run the repeatable static checks from any working directory:

```bash
./scripts/check.sh
```

For windowed checks with the installed Plasma SDK:

```bash
/usr/lib/qt6/bin/qmllint -I /usr/lib/x86_64-linux-gnu/qt6/qml package/contents/ui/main.qml
plasmoidviewer -a package -l bottomedge -f horizontal
plasmoidviewer -a package -l leftedge -f vertical
QT_SCALE_FACTOR=2 plasmoidviewer -a package -l bottomedge -f horizontal
```

Install or update the development package for the current user (no `sudo`), then
remove it when it is no longer needed:

```bash
./scripts/install.sh
./scripts/uninstall.sh
```

For an installed development package:

```bash
plasmawindowed io.github.apophuy.applicationlauncher
QT_LOGGING_RULES='qml.debug=true' plasmawindowed io.github.apophuy.applicationlauncher
journalctl --user -f | grep -E 'plasmashell|qml|io.github.apophuy.applicationlauncher'
```

The final popup matrix must be run from the real panel, not inferred from these commands.

## Current Milestone 1 smoke-test record

Recorded on 2026-10-02 with Plasma Desktop 6.3.6, libplasma 6.3.5,
Qt 6.8.2, and `plasmoidviewer` from `plasma-sdk` 6.3.4-1:

| Check | Result |
| --- | --- |
| Static package check (`./scripts/check.sh`) | pass; only the documented host-context `qmllint` warnings |
| `plasmoidviewer`, horizontal bottom edge, offscreen | loaded; no project QML errors |
| `plasmoidviewer`, vertical left edge, offscreen | loaded; no project QML errors |
| `plasmoidviewer`, horizontal bottom edge, scale 2, offscreen | loaded; no project QML errors |
| `plasmoidviewer`, horizontal bottom edge, real Wayland session | loaded; no project QML errors |
| Installed real-panel lifecycle matrix | pending |

The timeout exit status in the automated viewer checks is expected: the viewer was
terminated after the observation interval. Offscreen portal, window-shadow, and
desktop-containment messages are host-environment diagnostics, not messages from
the Apophuy package.

Apophuy Application Launcher must pass the “activate another plasmoid” case with
any available peer applet. It does not depend on Simple Application Launcher for
runtime or testing.
