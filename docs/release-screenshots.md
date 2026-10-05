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

## Optional compatibility image

4. **Transparent panel and vertical placement**
   - Use a transparent right-edge panel.
   - Open the launcher and include the complete inward-opening popup.
   - This can serve both as a release image and as the remaining optional icon
     regression in `docs/testing.md`.

## Delivery

Provide the original PNG files. Suggested names are:

- `launcher-dark.png`
- `launcher-search.png`
- `appearance-settings.png`
- `vertical-transparent-panel.png` (optional)

After review, curated copies belong in `docs/screenshots/`, and the README may
embed the strongest one or two images.
