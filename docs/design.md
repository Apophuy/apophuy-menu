# Visual design system

## Direction

Apophuy uses Plasma layout behavior and native application icons, with a small
amount of restrained color and depth added for recognition. A compact tool row
places session actions next to search. Below it, a spacious category column and
a three-column application grid form the main workspace. Rounded cards and
one-pixel borders establish hierarchy without introducing decorative panels or
heavy shadows.

The default panel icon is an original, front-facing standing penguin created
after the required user reference review. Its soft pseudo-3D finish uses a
clear silhouette, controlled gloss, and restrained shadows so it remains
recognizable in a panel. The face and belly stay ivory; beak and feet stay
amber; the main body and flippers form one recolorable accent region. The
user-provided flat penguin is a second built-in variant for users who prefer a
more direct, high-contrast panel mark.

The Appearance page offers the approved original green palette, Ocean, Amber,
Violet, and a custom color. The pseudo-3D penguin recolors only its accent
region, preserving the volume and contrast of its fixed features; the flat
penguin recolors its complete opaque silhouette while retaining its transparent
face area. A system-launcher icon remains available as a functional fallback.

## Theme modes

The Appearance page stores one integer setting per applet instance:

| Value | Mode | Behavior |
| --- | --- | --- |
| `0` | Follow system | Derive the base, text, highlight, and status colors from the active Kirigami Window palette |
| `1` | Light | Use the Apophuy light palette independently of the global color scheme |
| `2` | Dark | Use the Apophuy dark palette independently of the global color scheme |

Follow system is the default. `SystemPalette.qml` reads the host palette outside
the customized popup subtree. It supplies safe dark fallbacks during the short
startup interval in which Plasma may not yet expose every palette role.

## Semantic tokens

`DesignTokens.qml` is the only source of product palette values. UI components
consume semantic names rather than literal surface or state colors:

| Token | Use |
| --- | --- |
| `background` | Popup base |
| `elevatedBackground` | Search, system-action, navigation, and application cards |
| `primaryText` | Primary labels |
| `secondaryText` | Placeholder, disabled, and empty-state text |
| `border` | Card and idle field outlines |
| `hover` | Pointer hover state |
| `selected` / `selectedText` | Current category, favorite mode, and pressed state |
| `accent` / `focus` | Keyboard focus and active field outline |
| `success` | Positive semantic state |
| `warning` | Caution/neutral semantic state |
| `destructive` | Destructive semantic state |

The root full representation applies these values to Kirigami's attached Theme
properties so native Plasma labels and controls share the same foregrounds. The
project-owned backgrounds use the tokens directly because Plasma SVG control
backgrounds always follow the global Plasma theme and cannot represent an
explicit per-applet Light or Dark override reliably.

## System actions

System actions retain Plasma's native action model, localized labels, and
distinct glyph shapes. The narrow tool-row area exposes two labeled groups
instead of an ambiguous strip of seven icon-only buttons:

- `Session` contains Lock, Log Out, Save Session, and Switch User.
- `Power` contains Suspend, Hibernate, Restart, and Shut Down.

This is the same semantic split used by the installed Plasma 6 Kickoff. Opening
either group shows a native Plasma menu with the complete action names, reducing
visual density and the chance of an accidental destructive action. Each group
button keeps a compact pseudo-3D tile made from a vertical tonal gradient, a
restrained top highlight, and a two-pixel lower shadow.

The semantic action colors remain available for action-specific presentation:

| Action ID | Hue |
| --- | --- |
| `lock-screen` | ochre/gold |
| `logout` | teal |
| `suspend` | blue |
| `hibernate` | violet |
| `reboot` | amber/orange |
| `shutdown` | red |
| `switch-user` | cyan/teal |
| `save-session` | green |

White glyph contrast against every base action color is checked at or above
4.5:1 by `tests/qml/tst_DesignTokens.qml`. Color is never the only cue: both
group buttons have text, every menu row has Plasma's native action glyph and
localized label, and keyboard focus adds a visible accent outline around the
complete button.

## Interaction states

- Hover uses the semantic `hover` fill.
- Selection and press use `selected` with `selectedText`.
- Keyboard focus uses a two-pixel `focus` outline.
- Disabled navigation is reduced in opacity but remains legible.
- Grouped system-action buttons expose menu semantics and localized accessible
  names; their menu rows combine native glyphs with full labels.
- Favorite controls remain discoverable but use reduced idle opacity so they do
  not compete with application icons and labels.

No state animation, focus timer, or extra focus-forcing behavior was introduced
by the visual milestone. Popup lifecycle behavior therefore remains owned by
the existing Plasma representation contract.
