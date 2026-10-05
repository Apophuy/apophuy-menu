# Release screenshot checklist

The release screenshots are supplied by the user from the actual Plasma 6
Wayland panel. Do not substitute `plasmawindowed`, generated mockups, or agent
desktop captures for these images.

Use PNG format and keep the UI language consistent within the set. Hide or crop
notifications, clocks, account names, open-document titles, and other personal
information. Do not rescale screenshots after capture.

## Required set

1. **Main launcher, dark appearance**
   - Open the launcher from a horizontal panel.
   - Select a normal application category.
   - Keep the search field empty.
   - Include the complete popup and enough of the panel to show the Apophuy icon.

2. **Favorites and search**
   - Use the Light or Follow System appearance, whichever is visually distinct
     from the first image.
   - Enter a harmless application query that produces several results.
   - Include the complete popup, visible focus, and at least one filled Favorite
     star elsewhere if the current layout makes that possible.

3. **Appearance settings**
   - Open the widget's Appearance settings page.
   - Show the icon-style selector, theme selector, and color/accent choices.
   - Use one non-default color preset so the preview demonstrates recoloring.

## Delivery

Provide the original PNG files. Suggested names are:

- `launcher-dark.png`
- `launcher-search.png`
- `appearance-settings.png`

## README selection

The README uses two product views:

1. `launcher-dark.png` is the primary image. Use the final dark 100% screenshot
   with the 4 px Session and Power button padding.
2. `launcher-search.png` is the supporting image. It demonstrates the distinct
   Light appearance and active search results.

`appearance-settings.png` documents customization and remains in
`docs/screenshots/`, but is not embedded in the README.

## Review status

The user supplied all three requested views on 2026-10-05. Their composition and
content are accepted. The original PNG files still need to be copied into
`docs/screenshots/` under the names above before the release is tagged. Once
they are present, embed `launcher-dark.png` and `launcher-search.png` directly
below the README introduction.
