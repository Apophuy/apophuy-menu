# Architecture

## Status and scope

The working product name is **Apophuy Menu** and the provisional package ID is `io.github.apophuy.menu`. The first release targets Debian 13, Plasma 6.3.x, Qt 6.8, KF6 6.13, and Wayland. X11 compatibility is opportunistic and must not shape the design.

Milestone 0 deliberately contains no plasmoid UI. This document defines the boundary for Milestone 1 and later implementation.

## Package boundary

The deliverable is a pure Plasma KPackage under `package/` with `metadata.json` and `contents/ui/main.qml`. `main.qml` will have a `PlasmoidItem` root and explicit compact/full representations. Build scripts, tests, translations, and documentation remain outside the package.

No C++ or other custom backend is planned. A backend may be proposed only after documenting a requirement that cannot be met through the installed Plasma/KF6 models.

## Runtime layers

```text
Plasma panel / AppletPopup
        |
        v
PlasmoidItem (expanded, focus, compact/full representations)
        |
        +-- UI components (Kirigami + Plasma Components)
        |
        +-- launcher model adapter in main.qml
                |
                +-- Kicker.RootModel      categories/apps/favorites
                +-- Kicker.RunnerModel    Plasma Search/KRunner
                +-- Kicker.SystemModel    available session/power actions
```

The "adapter" is a small QML ownership boundary, not a duplicate data model. UI files receive models and call their public-to-QML methods instead of knowing how desktop entries or sessions are implemented.

## Plasma model decisions

The installed Plasma 6.3.6 Kickoff and Kicker both use `org.kde.plasma.private.kicker`. There is no equivalent public QML application-launcher model installed on the target system. Reusing it is therefore the narrowest QML-first solution, with an explicit private-API compatibility risk.

Initial API surface:

| Need | Plasma type/API |
| --- | --- |
| Categories and applications | `Kicker.RootModel`, `modelForRow()`, model roles such as `display`, `decoration`, `description`, `favoriteId`, `hasChildren`, `actionList`, `disabled` |
| Launch application / desktop action | model `trigger(row, actionId, argument)` |
| Refresh after package changes | native `KSycoca::databaseChanged` handling inside `AppsModel` |
| Favorites | `rootModel.favoritesModel` (`KAStatsFavoritesModel`) |
| Add/remove/reorder favorites | `addFavorite`, `removeFavorite`, `moveRow` |
| Search | `Kicker.RunnerModel` with `mergeResults: true`; result model from `modelForRow(0)` |
| System actions | `Kicker.SystemModel`, whose rows are already filtered by current system capability |

Direct private Kicker use should remain concentrated in `main.qml` and model-facing components. Every Plasma upgrade requires checking these types against the matching source before declaring compatibility.

### Favorites identity

Use `KAStatsFavoritesModel.initForClient()` with an Apophuy-specific, per-instance client ID. Do not impersonate the stock Kickoff client ID: that would couple independent plasmoid instances and rely on undocumented storage identity. A one-time import/migration can be designed later if users need existing Kickoff favorites copied.

### Launch semantics

Application and desktop-action launches go through the model's `trigger()` method. In Plasma 6.3.6 this delegates to `KIO::ApplicationLauncherJob` and records KActivities usage. Project code must not execute `.desktop` command lines itself.

## Popup lifecycle

Milestone 1 starts with Plasma's native lifecycle:

- `preferredRepresentation: compactRepresentation`;
- compact press records the prior `expanded` value and click toggles from that value, matching current Kickoff;
- `Plasmoid.activationTogglesExpanded = true` for global-shortcut/button reactivation;
- `hideOnWindowDeactivate: true` with no pin mode in the first version;
- successful application, search result, desktop action, or system action sets `expanded = false`;
- Escape sets `expanded = false`;
- no close timers and no blanket focus forcing.

`PlasmoidItem` defaults `hideOnWindowDeactivate` to true in installed libplasma 6.3.5. It will still be set explicitly to make the invariant visible. The backing `AppletPopup` handles focus loss and preserves focus for transient child popups. This behavior must be validated in a real Wayland panel because `plasmawindowed` explicitly disables hide-on-deactivate.

## UI composition direction

The first functional layout keeps only:

- a search field;
- a compact favorites region;
- a category list;
- one virtualized application/result list;
- a small system-action strip.

Places, recent documents, user avatar, profile editing, complex footer modes, nested pages, and a pin/keep-open feature are out of the initial scope. This keeps focus traversal and popup state small enough to test rigorously.

## Theme and assets

Theme values will be centralized as semantic QML properties derived from Kirigami/Plasma colors. Light, dark, and follow-system behavior are later milestones. Until the icon reference gate is satisfied, only a temporary vector development icon may be used.

## Compatibility gates

Before claiming support for a new Plasma version:

1. compare every used private Kicker property, role, signal, and method with the new source;
2. inspect current Kickoff/Kicker close and focus handling;
3. run static QML/package checks;
4. rerun the full popup regression matrix in `docs/testing.md` on Wayland.
