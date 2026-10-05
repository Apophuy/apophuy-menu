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

Run QML runtime tests from the active Plasma user session:

```bash
./scripts/test-runtime.sh
```

The runtime suite uses a dedicated KActivities client ID and removes its test
favorite during cleanup. It does not use the installed applet instance's
favorites namespace.

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
| Installed real-panel lifecycle matrix | Milestone 1 core pass; remaining feature-dependent cases listed below |

The timeout exit status in the automated viewer checks is expected: the viewer was
terminated after the observation interval. Offscreen portal, window-shadow, and
desktop-containment messages are host-environment diagnostics, not messages from
the Apophuy package.

Apophuy Application Launcher must pass the “activate another plasmoid” case with
any available peer applet. It does not depend on Simple Application Launcher for
runtime or testing.

### Real-panel run on 2026-10-02

The development package was installed for the current user and tested in the
actual Plasma Wayland session. Both displays were 3840×2160 at 150% scale, with
an effective 2560×1440 geometry. The test instance was first placed on the top
panel of screen 0 and then moved to the top panel of screen 1.

| Scenario | Result |
| --- | --- |
| 100 sequential open/close cycles (200 native activation calls, 300 ms interval) | pass |
| 100 fast alternating activations (50 ms interval) | pass |
| 20 open → activate another plasmoid → close peer cycles | pass |
| 20 open → show desktop → restore windows cycles | pass |
| Outside-focus closure during direct panel interaction | pass |
| Project QML errors, crashes, failed activation calls | none observed |

The automation invoked the applet's native KGlobalAccel activation action; it did
not inject synthetic Wayland pointer events. The temporary shortcut was removed
after the run. The applet remains on the top panel of screen 1 for continued
manual and feature testing.

Escape, application launch, and search-result launch remain in the regression
matrix. The latter two become testable when their Milestones are implemented.
Real vertical-panel coverage also remains pending; the vertical representation
has so far passed only the `plasmoidviewer` smoke test.

## Current Milestone 2 smoke-test record

The first application-model implementation was checked on 2026-10-02:

| Check | Result |
| --- | --- |
| Static QML/package checks | pass; only documented host-context lint warnings |
| `Kicker.RootModel` load through offscreen `plasmoidviewer` | pass; no project QML errors |
| Installed model load in the real Wayland panel on screen 1 | pass; no project QML errors |
| Category selection and application icons | pending direct interaction check |
| Successful application launch and popup closure | pass; direct Wayland-panel check confirms the application starts and the launcher closes |

The implementation calls the selected Kicker child model's `trigger()` method
and closes the applet only when that method reports success. It does not parse or
execute desktop files itself.

## Current Milestone 3 smoke-test record

The first Favorites implementation was checked on 2026-10-02:

| Check | Result |
| --- | --- |
| Static QML/package checks | pass; only documented host-context lint warnings |
| Favorites UI load through offscreen `plasmoidviewer` | pass; no project QML errors |
| Favorites UI load in the installed Wayland panel instance | pass; no project QML errors |
| Isolated KActivities add → refresh → remove test | pass |
| Add/remove through the visible star control | pending direct interaction check |
| Launch from the visible Favorites list | pass; direct Wayland-panel check confirms launch and popup closure |

Favorites use the native per-instance `KAStatsFavoritesModel` namespace. The UI
does not maintain a separate favorites file or impersonate another launcher's
client identity.

## Current Milestone 4 smoke-test record

The first search implementation was checked on 2026-10-02:

| Check | Result |
| --- | --- |
| Static QML/package checks | pass; only documented host-context lint warnings |
| Search UI and `RunnerModel` load through offscreen `plasmoidviewer` | pass; no project QML errors |
| Application-runner query for KCalc | pass; at least one result returned |
| Search UI load in the installed Wayland panel instance | pass; no project QML errors |
| Type query, navigate results, Enter launch | pass; direct Wayland-panel check confirms result launch through `Enter` and popup closure |
| Two-stage Escape | pass; direct Wayland-panel check confirms the first press clears the query and the second closes the launcher |

The automated query test limits its runner set to `krunner_services` so unrelated
headless runner failures cannot hang the suite. The product model intentionally
keeps Plasma's configured runner set. `scripts/test-runtime.sh` terminates after
30 seconds if a runtime dependency fails to respond.

## Current Milestone 5 smoke-test record

The first system-actions implementation was checked on 2026-10-02:

| Check | Result |
| --- | --- |
| Static QML/package checks | pass; only documented host-context lint warnings |
| System-actions UI load through offscreen `plasmoidviewer` | pass; no project QML errors |
| Available-actions model and disabled-role test | pass |
| Installed package matches the checked working-tree package | pass |
| Invoke Lock, Logout, Suspend, Hibernate, Restart, and Shutdown from the visible controls | pending deliberate manual checks |

The UI is populated by Plasma's native `SystemModel`, so actions unavailable on
the current machine are omitted and disabled entries cannot be invoked. Automated
tests intentionally inspect availability without triggering session or power
operations. A successful native `trigger()` closes the launcher popup.

## Current Milestone 6 smoke-test record

The visual design implementation was checked on 2026-10-04:

| Check | Result |
| --- | --- |
| Static QML/package checks | pass; only documented host-context lint warnings |
| Semantic token unit tests | pass for System, Light, and Dark mode selection |
| White glyph contrast for all eight known system-action IDs | pass at 4.5:1 or greater |
| Explicit-theme primary, secondary, and selected text contrast | pass at the documented 7:1 / 4.5:1 thresholds |
| Full runtime suite | pass; 15 tests across design tokens, Favorites, RunnerModel, and SystemModel |
| KPackage upgrade in the user plasmoid directory | pass |
| Full representation reload in the real Wayland panel on screen 2 | pass; fixed-height tool row, category column, and three-column application grid render correctly |
| Follow system visual review | pass; system action hues, pseudo-depth, card hierarchy, spacing, and legibility verified at 150% scale |
| Explicit Light and Dark visual review | pass; user screenshots verified both palettes at 150% scale |
| Selected and keyboard-focus state review | pass; category selection and search focus are distinct in panel screenshots |
| Hover state review | pending direct interaction check |

The initial `SystemPalette` load exposed that Plasma may briefly report some
palette roles as undefined while rebuilding the shell. Semantic fallbacks now
cover that startup interval. A call to Plasma 6.3.6's `refreshCurrentShell()`
caused the old shell process to crash during shutdown; systemd restored
`plasmashell` automatically after roughly two seconds. Do not use that method as
the routine development reload path on this target system.

The first wide-layout revision only assigned a preferred height to its tool row.
Qt Quick Layouts allowed the row's fill-height children to consume the popup,
pushing the workspace below the visible bounds. Equal minimum, preferred, and
maximum tool-row heights now make that constraint deterministic. The corrected
layout was reloaded and visually verified in the real panel with no project QML
errors in the journal.

## Current localization smoke-test record

The first English/Russian gettext catalog was checked on 2026-10-04:

| Check | Result |
| --- | --- |
| POT extraction and PO syntax checks | pass |
| English and Russian MO compilation | pass |
| Catalog copied into the installed KPackage | pass |
| Russian panel UI | pass; search and Favorites render as `Поиск приложений…` and `Избранное` |

## Grouped system-actions regression

The icon-only action strip was replaced after the 2026-10-04 panel review. The
installed Plasma 6 grouping is preserved: session actions and power actions are
shown behind two labeled menu buttons.

| Check | Result |
| --- | --- |
| Labeled group buttons at 150% scale | pass; `Сеанс` and `Питание` fit without crowding |
| Power menu contents | pass; Sleep, Hibernate, Restart, and Shut Down appear with localized labels and native glyphs |
| Menu opening and launcher lifetime | pass; the native menu opens without dismissing the launcher |
| Project QML errors after opening the menu | pass; none in the user-service journal |
| Session menu contents, Escape, and successful action close | pending direct interaction checks |

## Launcher icon regression

The final icon reference gate was completed on 2026-10-04. The user supplied a
flat silhouette reference, a volumetric penguin reference, and a project-owned
pseudo-3D icon reference. The accepted result is an original, front-facing,
standing penguin; it is not a copied Tux asset.

| Check | Result |
| --- | --- |
| Original green icon at 16, 22, 24, 32, 48, and 64 px | pass in image-size QA; silhouette remains readable |
| Packaged 512 px source and accent mask | pass; both preserve alpha |
| Original palette / color-mask separation | pass; mask affects the green body and flippers, preserving face, belly, eyes, beak, and feet |
| Static QML, package, and translation checks | pass; only documented host-context lint warnings |
| Installed Plasma 6 panel, dark theme, original palette | pass; user screenshot confirms the embedded penguin renders in the compact representation |
| Installed Plasma 6 panel, dark theme, Ocean preset | pass; user screenshot confirms only the intended accent area is recolored |
| Flat penguin, dark panel, Ocean preset | pass; user screenshot confirms every opaque green pixel is recolored while the transparent face remains panel background |
| Compact-representation icon margins | pass; both bundled penguin variants fill the compact representation with no project-side padding or margins |
| Real Plasma panel at 100%, 150%, and 200% scale | pass; user screenshots confirm a crisp, complete flat-penguin silhouette at every scale |
| Light real-panel background, flat and pseudo-3D variants | pass; user screenshots confirm both panel-icon variants retain contrast and a legible silhouette |
| Transparent real-panel background | pending optional regression screenshot |
