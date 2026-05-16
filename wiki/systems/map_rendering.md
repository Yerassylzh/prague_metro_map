# System: Map Rendering

## Overview

Map rendering draws and interacts with the offline schematic metro map, including line paths, station markers, translated labels, transfer connectors, line-number badges, route highlights, and floating action buttons below the top ad banner.

## Coordinate System

- Station coordinates are normalized values stored on each station record.
- The visible map converts normalized coordinates into a large fixed canvas:
  - width: 900 logical pixels.
  - height: 1500 logical pixels.
  - top margin: 80 logical pixels.
  - left margin: 0 logical pixels.
- Some stations and bend points use coordinates greater than `1.0`; this is intentional because the schematic extends below the original normalized bounds.
- The map widget adds extra empty canvas space around the drawing so users can pan without the network sticking to the viewport edge.

## Rendering Stack

```
MapScreen
    |
    v
Column
    |-- TopAdBanner
    |-- Expanded map Stack
        |-- MetroMap
        |   |-- InteractiveViewer
        |   |-- fixed canvas
        |   |-- CustomPaint(MetroMapPainter)
        |   |-- station dots, labels, line badges
        |-- floating review button
        |-- floating feedback/menu button
        |-- RouteDetailsSheet
```

## Viewport Behavior

- `InteractiveViewer` owns zoom and pan.
- Initial transform starts at 50% scale so more of the network is visible on first load.
- Minimum scale is 1.0 and maximum scale is 5.0.
- The viewer is unconstrained, which lets the fixed schematic canvas be larger than the screen.
- Boundary margin gives the user room to pan around the map.

## Line Drawing

`MetroMapPainter` draws in this order:

1. **Base metro lines**
   - Each `MetroLine.path` is drawn as a polyline.
   - Path nodes can be real stations or visual-only bend points.
   - The path list is for rendering; the station list is for route logic.

2. **Base transfer connectors**
   - Transfer pairs are drawn as gray dashed walking lines.
   - Pairs are canonicalized before drawing so A-B and B-A are not drawn twice.
   - Same-position transfers can be represented by transfer hub markers.

3. **Active route highlight**
   - Route metro segments are drawn with a white border underneath and a colored line on top.
   - Route transfer segments are drawn as black dashed walking connections above colored metro segments.
   - Base network opacity drops when a route is active.

4. **Focused line highlight**
   - When a line badge is selected, stations and lines outside that line are dimmed.
   - Focused line mode is independent from route mode.

5. **Transfer hubs**
   - Same-position transfers are rendered as a small rotated capsule with colored interlocking rings.
   - The white capsule masks the line intersection underneath and makes the transfer marker readable.

## Station Dots and Labels

Station markers are widgets overlaid above the painter:

| State | Visual |
|-------|--------|
| Default | Colored circle using the station line color |
| Transfer | Larger tap target; hub rendering is handled by the painter |
| From station | Blue marker with origin icon |
| To station | Green marker with destination icon |
| On active route | Normal label weight and route-highlighted line |
| Off active route | Gray dot and dimmed label |
| Off focused line | Gray dot and dimmed label |

Labels:

- Use the active app language through `Station.getLocalizedName`.
- Are placed with per-station overrides for busy intersections and transfer areas.
- Fall back to line-level placement rules:
  - Line A: mostly bottom, with center and endpoint overrides.
  - Line B: mostly bottom, with center and endpoint overrides.
  - Line C: mostly right, with north/south overrides.

## Line-Number Badges

Line-number badges are circular tap targets placed near selected line endpoints.

Rules:

- The badge text is the line number.
- Badge color is the line color.
- Text switches between white and dark based on color luminance.
- Tapping a badge toggles focused-line mode.
- A selected badge grows slightly with a short animation.
- Some endpoint badges are intentionally hidden because they overlapped nearby labels:
  - No Prague endpoint badges are hidden by default.

## Top Floating Buttons

Two circular buttons are positioned above the map content:

| Side | Visual | Action |
|------|--------|--------|
| Left | `review_button.gif` animation | Opens Google Play / market page |
| Right | menu icon | Opens the feedback screen |

These buttons live inside the map stack below the top banner. The route details sheet is drawn after them, so an expanded sheet covers the buttons instead of the buttons floating above the sheet.

## Interaction

- Tapping a station dot calls the map's station selection callback.
- Tapping a station label also selects the station.
- Tapping a line badge toggles line focus.
- Pinch, scroll, and drag are handled by `InteractiveViewer`.
- Floating buttons trigger feedback/review actions without affecting route state.

## Data Flow

```
MetroData stations and line paths
    |
    v
MetroMap receives from/to/route/focusedLineId state
    |
    v
MetroMapPainter draws lines and transfer connectors
    |
    v
MetroMap overlays station dots, translated labels, and line badges
    |
    v
User taps station or line badge
    |
    v
MapScreen updates route selection or focused-line state
```

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| Missing station in a line path | That path node is skipped |
| Transfer pair listed in both stations | Only one dashed connector is drawn |
| Transfer stations share exact coordinates | Connector is represented by a hub marker instead of a visible long line |
| Active route includes transfer pair | Base transfer connector is skipped; active transfer connector is drawn on top |
| Route uses only part of a line | Highlight follows the visual path between adjacent route stations, including bend points |
| Station not on active route | Dot and label are dimmed |
| Station not on focused line | Dot and label are dimmed |
| Line badge would overlap text | Badge is hidden or offset by explicit rules |

## Dependencies

- `MetroData` for station positions, line colors, station order, path bend points, and transfer pairs.
- `MetroRoute` and `RouteSegment` for active route station IDs and line IDs.
- `TranslationService` for map labels.
- `AppReviewService` and `FeedbackScreen` for floating button actions.
- Flutter `CustomPainter`, `InteractiveViewer`, `Stack`, `Positioned`, and gesture widgets.

## Future Considerations

- Improve initial viewport framing so the first visible area is chosen intentionally per screen size.
- Add collision-aware label and line-badge placement if station density increases.
- Add curved or angled transfer connectors where same-position hub markers are not enough.
- Consider extracting floating map actions into a separate widget if more map actions are added.
