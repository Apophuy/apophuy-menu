# Launcher research: Plasma 6 Kickoff, Kicker, and Simple Kickoff

## Material inspected

- Installed `org.kde.plasma.kickoff` and `org.kde.plasma.kicker` from Plasma Workspace `6.3.6-2`.
- Matching Debian `plasma-workspace 6.3.6-2` source, especially `applets/kicker/plugin`.
- Matching Debian `libplasma 6.3.5-1` source, especially `PlasmoidItem` and `AppletPopup`.
- User-installed Simple Application Launcher 2.5 (`org.kde.plasma.simplekickoff`),
  plus its matching upstream commit `8a99d70ea20b16fb624fc7ce3de005271178f40f`
  dated 2024-03-08.
- Official [Plasma widget setup](https://develop.kde.org/docs/plasma/widget/setup/), [KF6 porting guide](https://develop.kde.org/docs/plasma/widget/porting_kf6/), [testing guide](https://develop.kde.org/docs/plasma/widget/testing/), and [PlasmoidItem API](https://api.kde.org/qml-org-kde-plasma-plasmoid-plasmoiditem.html).

## Current Plasma model stack

Both stock launchers import `org.kde.plasma.private.kicker` and rely on its native models instead of reading desktop files in QML.

### Applications and categories

`Kicker.RootModel` builds application categories from KDE's service database. With `flat: true`, categories remain but nested subcategories are flattened. `modelForRow()` exposes the model for a selected category. It can also prepend special groups for favorites, all applications, recent usage, and power/session actions.

`AppsModel` listens to `KSycoca::databaseChanged` and refreshes after a short native debounce, so a separate project file watcher is unnecessary.

The useful model roles are `display`, `decoration`, `compactName`, `description`, `favoriteId`, `isParent`, `isSeparator`, `hasChildren`, `hasActionList`, `actionList`, `url`, and `disabled`.

### Launch and desktop actions

Rows are activated through `trigger(row, actionId, argument)`. A normal application launch uses `KIO::ApplicationLauncherJob`; jump-list/desktop actions use a `KServiceAction`. Successful triggers return true, which stock Kickoff uses as the signal to close the popup.

### Favorites

`RootModel.favoritesModel` is a `KAStatsFavoritesModel`. It supports initialization by client ID, add/remove, activity association, and reordering. Current Kickoff initializes a per-plasmoid client such as `org.kde.plasma.kickoff.favorites.instance-<id>`; Kicker uses its own namespace.

Conclusion: reuse the same KActivities-backed model technology, but use an Apophuy-specific client ID. Sharing Kickoff's literal client identity would be brittle. If importing existing favorites becomes a requirement, implement a bounded migration rather than permanent namespace impersonation.

### Search

`Kicker.RunnerModel` wraps KRunner/Plasma Search. Kickoff binds its `query` to the search field, enables `mergeResults`, supplies the favorites model, and displays `modelForRow(0)`. The model delays and runs queries internally and emits `queryFinished`; no local index is needed.

Kicker demonstrates a smaller runner allow-list (`krunner_services`, system settings, sessions, PowerDevil, calculator, unit converter), whereas Kickoff accepts the configured Plasma Search set. For the first version, search should prioritize applications and use the installed Plasma configuration; runner scope can be narrowed only after UX testing.

### System actions

`Kicker.SystemModel` creates Lock, Log Out, Save Session, Switch User, Suspend, Hibernate, Restart, and Shut Down entries. Invalid actions are excluded according to `SessionManagement` capability signals. This directly satisfies the requirement not to show unsupported hibernate/power actions.

## Popup and focus behavior

Current Kickoff uses a `PlasmoidItem` with compact and full representations, `preferredRepresentation: compactRepresentation`, and `Plasmoid.activationTogglesExpanded = true`. Its custom compact representation records `wasExpanded` on press and sets `expanded = !wasExpanded` on click. This avoids basing the toggle on state that Plasma may have changed during activation.

`PlasmoidItem` in libplasma 6.3.5 defaults `hideOnWindowDeactivate` to true. The underlying `AppletPopup::focusOutEvent` hides only when neither an acceptable transient parent nor a transient child popup has focus. Stock Kickoff binds this property to its optional "Keep Open" setting; Apophuy Menu will initially omit pinning and keep it true.

After a successful row/action trigger, stock Kickoff sets `expanded = false` when hide-on-deactivate is active. Kicker similarly closes after launches, Enter, Escape, and system actions. These explicit state transitions should be retained rather than waiting for the launched application to steal focus.

`plasmawindowed` is useful for loading and interaction checks but its implementation sets `hideOnWindowDeactivate` to false. It cannot prove the main outside-click regression fixed. That acceptance test belongs in a real Wayland panel.

## Simple Kickoff findings

The target workstation already uses Simple Application Launcher 2.5. Its
installed package is byte-for-byte equivalent to the inspected upstream
checkout, apart from repository-only files. It was inspected only as the UX
reference required by the implementation plan; Apophuy Menu
does not depend on or modify it.

Simple Kickoff is a simplified fork of an older Kickoff. Its UX changes are useful:

- no Places page;
- no prominent configure control;
- favorites, categories, and applications remain central;
- search and session controls share a compact header;
- list/grid options retain familiar Kickoff behavior.

It is not a suitable technical base. The checkout uses versioned Qt 5-era imports (`QtQuick 2.15`, `org.kde.plasma.plasmoid 2.0`, and similar), includes `Qt5Compat.GraphicalEffects`, and has diverged from fixes in installed Plasma 6.3.6. Its source was last committed in March 2024 and is structurally close to copied Kickoff code rather than a small independent launcher.

Conclusion: retain its visual simplicity and information hierarchy, but implement against the installed Plasma 6 code and unversioned imports.

## Parts intentionally excluded from the first implementation

- Places and storage devices.
- Recent/frequent documents and applications.
- User avatar/profile editing.
- Pin/keep-open mode.
- Multiple nested stack views and animated category transitions.
- Application editor shortcut in the primary UI.
- Dashboard/full-screen mode.
- Custom application database, search index, or launch backend.

Each excluded feature increases focus, navigation, or private-API surface. It can be reconsidered only after the minimal launcher meets the popup reliability acceptance criterion.

## Main risk

The Kicker QML plugin is explicitly private. It is nevertheless the model used by the target Plasma's own launchers and is the only installed native QML-first route that fulfills the application requirements. The mitigation is isolation, exact-version source review, a compatibility gate on upgrades, and avoiding undocumented behavior beyond the small API recorded in `docs/architecture.md`.
