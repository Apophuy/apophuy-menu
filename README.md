# Apophuy Menu

[Русская версия](README_RU.md)

Apophuy Menu is a compact, predictable application launcher for KDE Plasma 6. It
uses Plasma's own application, favorites, search, and session models while
keeping the interface deliberately small.

The first release targets Debian 13 (Trixie), KDE Plasma 6.3, Qt 6.8, KDE
Frameworks 6.13, and Wayland.

## Screenshots

![Apophuy Menu in its dark appearance](docs/screenshots/launcher-dark.png)

![Apophuy Menu search in its light appearance](docs/screenshots/launcher-search.png)

## Features

- Plasma application categories and native application launching
- Per-instance Favorites with visible add/remove controls
- KRunner-powered search and keyboard result launching
- Grouped native Session and Power actions
- Follow System, Light, and Dark color modes
- Original and flat Apophuy Penguin panel icons with recoloring presets
- English and Russian interfaces
- Keyboard navigation, visible focus states, and HiDPI-aware layout

Release screenshots are captured by the user from the real Plasma Wayland
panel. The selected and supporting views are documented in
[`docs/release-screenshots.md`](docs/release-screenshots.md).

## Install

The development checkout can be installed for the current user without root:

```sh
./scripts/install.sh
```

Alternatively, install a release archive:

```sh
kpackagetool6 --type Plasma/Applet --install apophuy-application-launcher-0.1.2.plasmoid
```

After installation, enter Plasma panel edit mode, choose **Add Widgets**, and
add **Apophuy Menu**. Existing installations can be updated by
replacing `--install` with `--upgrade`.

## Uninstall

From a checkout:

```sh
./scripts/uninstall.sh
```

Or directly:

```sh
kpackagetool6 --type Plasma/Applet --remove io.github.apophuy.applicationlauncher
```

Removing the widget from a panel does not uninstall its package. Logging out is
normally unnecessary after installation or removal, although Plasma may need to
reopen the widget browser before its list refreshes.

## Build and verify

Required development tools include Qt 6 QML tools, `kpackagetool6`, gettext,
`xmllint`, `zip`, `unzip`, and `sha256sum`. Run the static checks and Plasma
runtime model tests with:

```sh
./scripts/check.sh
./scripts/test-runtime.sh
```

Build a versioned `.plasmoid` archive and its SHA-256 checksum in `dist/` with:

```sh
./scripts/package-release.sh
```

The runtime suite must run inside an active Plasma user session. Popup focus and
outside-click behavior must still be verified from a real Wayland panel; the
windowed Plasma tools cannot reproduce that contract completely. See
[`docs/testing.md`](docs/testing.md) for the test matrix and current results.

## Architecture and compatibility

Apophuy is QML-only and does not scan desktop files or maintain a separate
application database. It intentionally uses Plasma's private Kicker QML models
because Debian 13's Plasma installation exposes no equivalent public launcher
model. This narrow dependency is documented in
[`docs/architecture.md`](docs/architecture.md) and must be rechecked for every
new Plasma release.

## License

Copyright © 2026 Apophuy. Licensed under the GNU General Public License,
version 3 or any later version. See [`LICENSE`](LICENSE).
