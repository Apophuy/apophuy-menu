# Development environment

Inventory captured on 2026-10-02. Commands were run against the actual target workstation; versions below are not assumptions.

## Platform

| Component | Detected value | Evidence |
| --- | --- | --- |
| Distribution | Debian GNU/Linux 13.7 (Trixie) | `/etc/os-release` (`DEBIAN_VERSION_FULL=13.7`) |
| Kernel | `6.12.111+deb13-amd64` | `uname -a` |
| Desktop/session | KDE on Wayland | `XDG_CURRENT_DESKTOP=KDE`, `XDG_SESSION_TYPE=wayland`, `WAYLAND_DISPLAY=wayland-0` |
| Plasma Desktop | `6.3.6-1` | Debian package `plasma-desktop` |
| Plasma Workspace | `6.3.6-2` | Debian package `plasma-workspace` |
| libplasma | `6.3.5-1` | Debian package `libplasma6` |
| Qt | `6.8.2` | `qtpaths6 --qt-version`, `qmake6 --version` |
| KDE Frameworks | `6.13.0` | installed KF6 runtime/QML packages, including `libkf6coreaddons6` |
| CMake | `3.31.6` | `cmake --version` |
| gettext | `0.23.1` | `xgettext --version`, `msgfmt --version` |

Running GUI programs from the coding sandbox cannot connect to the user's Wayland display (`Operation not permitted`). This is a sandbox limitation, not evidence that the Wayland session or Qt Wayland plugin is missing. Interactive panel tests must run in the user's desktop session.

## Plasma and QML locations

- System plasmoids: `/usr/share/plasma/plasmoids`
- Installed Kickoff: `/usr/share/plasma/plasmoids/org.kde.plasma.kickoff`
- Installed Kicker: `/usr/share/plasma/plasmoids/org.kde.plasma.kicker`
- Installed Application Dashboard: `/usr/share/plasma/plasmoids/org.kde.plasma.kickerdash`
- Qt/KF QML import root: `/usr/lib/x86_64-linux-gnu/qt6/qml`
- Private Kicker plugin: `/usr/lib/x86_64-linux-gnu/qt6/qml/org/kde/plasma/private/kicker`
- User plasmoid installation root: `~/.local/share/plasma/plasmoids`

Important available QML modules include Qt Quick, Qt Quick Controls, Qt Quick Layouts, Qt Test, Kirigami, Kirigami Addons, KItemModels, KQuickControls, KSvg, Plasma Core, Plasma Components, Plasma Extras, the Plasma plasmoid module, KWindowSystem, and Milou. The complete installed KDE module inventory can be regenerated with:

```bash
find /usr/lib/x86_64-linux-gnu/qt6/qml/org/kde -maxdepth 3 -type f -name qmldir -printf '%h\n' | sort
```

## Development and diagnostic tools

| Tool | Status | Notes |
| --- | --- | --- |
| `plasmawindowed` | installed | `/usr/bin/plasmawindowed`, from `plasma-workspace` |
| `plasmoidviewer` | missing | provided by Debian's `plasma-sdk` package |
| `plasma-sdk` | missing | candidate version `6.3.4-1` |
| `kpackagetool6` | installed | version `2.0` |
| `qmllint` | installed | Qt `6.8.2`; use `/usr/lib/qt6/bin/qmllint` |
| `qmlformat` | installed | Qt `6.8.2`; use `/usr/lib/qt6/bin/qmlformat` |
| `qmltestrunner` | installed | `/usr/lib/qt6/bin/qmltestrunner`; requires a usable GUI platform unless configured otherwise |
| `qmlprofiler`, `qmlls` | installed | under `/usr/lib/qt6/bin` |
| `xgettext`, `msgfmt`, `msgmerge` | installed | gettext `0.23.1` |
| `qdbus6`, `dbus-monitor` | installed | D-Bus inspection |
| `journalctl`, `coredumpctl`, `gdb` | installed | runtime diagnostics |
| `valgrind`, `apitrace`, `renderdoc` | not detected | not required for Milestone 0 |

Debian's runtime does not install a discoverable `qmldir`/QML type description for the context-provided `org.kde.plasma.plasmoid` module or the private Kicker plugin. Standalone `qmllint` therefore reports unresolved `PlasmoidItem`, `Plasmoid`, and `i18n` warnings even for system plasmoid code. Continue using it to catch parser and ordinary QML issues, but do not treat those specific host-context warnings as product defects. Type/runtime validation must also load the package through a Plasma host. Do not suppress other warning classes globally.

The only currently required root installation is Plasma SDK:

```bash
sudo apt install plasma-sdk
```

Do not run this from the coding agent. Once the user installs it, verify with `plasmoidviewer --version` and update this document.

## Exact source snapshots used for research

Matching Debian sources were downloaded without installation using:

```bash
cd /tmp
apt-get source plasma-workspace
apt-get source libplasma
```

The inspected snapshots were `plasma-workspace 6.3.6-2` and `libplasma 6.3.5-1`. Temporary source directories are not project dependencies and must not be referenced by shipped code.

The Simple Kickoff reference was cloned to a temporary directory at commit `8a99d70ea20b16fb624fc7ce3de005271178f40f` (2024-03-08). It is a research input only.

## Recheck after system upgrades

Run the following before compatibility work after any Plasma update:

```bash
dpkg-query -W -f='${Package}\t${Version}\n' plasma-desktop plasma-workspace libplasma6 libkf6coreaddons6 libqt6core6t64
qtpaths6 --qt-version
cmake --version
```

If Plasma or libplasma changed, refresh the matching Debian source and repeat the private Kicker and popup lifecycle audit before modifying the applet.
