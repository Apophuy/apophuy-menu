# Current work status

Updated: 2026-10-05

## Completed since `49065fe`

- Milestone 6 visual design: System, Light, and Dark palettes; semantic design
  tokens; grouped pseudo-3D session and power controls; reviewed selection,
  focus, and dark-theme hover states.
- Milestone 7 icon design: the user supplied the required flat and volumetric
  references; the launcher now includes an original front-facing pseudo-3D
  Apophuy Penguin, the supplied flat penguin, and the system icon fallback.
  Both bundled variants support the original palette plus Ocean, Amber, Violet,
  and a custom accent. Their real-panel rendering was verified at 100%, 150%,
  and 200% scale and on dark and light panel backgrounds.
- Milestone 8 localization: the gettext pipeline, English catalog, and Russian
  catalog are present; the Russian panel UI was verified in Plasma.
- Milestone 9 checks completed so far: actual KDE Wayland panel, both 4K
  displays, top and right-edge panels, keyboard application launch from
  Favorites and search, two-stage Escape, child-menu Escape, repeated
  plasmashell restarts, and dark-theme hover visibility.

The detailed results and exact manual scenarios are in
[`docs/testing.md`](docs/testing.md).

## Latest relevant commits

- `16a57ec fix: increase system action padding`
- `a24fd0a docs: prepare release handoff`
- `bb086ec fix: pad grouped system actions`
- `14a51b5 docs: record vertical panel validation`
- `58e4b10 docs: summarize hardening status`
- `d76d946 fix: strengthen dark hover state`
- `72c2a86 feat: clarify favorite state`
- `97fb9bd feat: add flat penguin icon`
- `1ec792f feat: add penguin launcher icon`

The installed development package includes the latest code changes.

## Milestone 10 progress

- Added the project README with current-user installation, update, uninstall,
  verification, packaging, and compatibility guidance.
- Added the GPL-2.0 license text and an initial changelog for version 0.1.0.
- Added a repeatable release script that builds translations, runs the static
  checks, creates a versioned `.plasmoid` archive, verifies ZIP integrity, and
  writes its SHA-256 checksum.
- Added `docs/release-screenshots.md`. Release screenshots must be supplied by
  the user from the actual Plasma Wayland panel; agent captures and
  `plasmawindowed` substitutes are not acceptable.
- The first 2 px side-padding revision for the grouped system-action buttons was
  still too tight in the user's 100% screenshot. It was revised to 4 logical
  pixels on each side, with the aligned left sidebar widened by 8 pixels. The
  revised package is installed, Plasma Shell has been restarted, and no Apophuy
  errors appeared in the restart journal.
- The user supplied the three requested release views: dark launcher, light
  search results, and Appearance settings. Their content is accepted; their
  original PNG files still need to be copied into `docs/screenshots/`.

## Resume from here

Milestone 9 is the active milestone. The remaining deliberate manual scenarios
are intentionally not automated because they affect the desktop session:

1. Suspend and resume, then open and use the launcher again.
2. With the user's consent, invoke one native system action and verify that the
   launcher closes exactly once and that no stale popup remains.

The remaining release work is:

1. User review of the revised Session and Power button padding at 100% scale.
2. Curate the three supplied screenshots listed in
   `docs/release-screenshots.md` from their original PNG files.
3. The two deliberate Milestone 9 session scenarios above.
4. Finish the changelog entry, rerun release checks, and tag the release only
   after every gate passes.

## Working tree note

The user-owned `assets/` concepts and
`plasma6_launcher_implementation_plan.md` are ignored locally and must remain
excluded from commits unless the user explicitly asks otherwise. Generated
translation catalogs and `dist/` release archives are also ignored.
