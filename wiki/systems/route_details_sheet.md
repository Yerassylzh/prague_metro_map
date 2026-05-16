# System: Route Details Sheet

## Overview

The route details sheet is the bottom control surface for selecting stations, inspecting one line, and reading a calculated route timeline.

## Modes

The sheet has three states:

| State | Trigger | UI |
|-------|---------|----|
| No route | No route and no focused line | Fixed bottom sheet with "From" and "To" station search fields |
| Focused line | User taps a line-number badge on the map | Draggable sheet showing all stations on that line |
| Route exists | Origin and destination produce a route | Draggable route summary with station timeline |

Priority:

1. Route mode wins when `route != null`.
2. Focused line mode is used when no route exists and `focusedLineId != null`.
3. Search-field mode is used when there is no route and no focused line.

## No-Route Mode

- The sheet is aligned to the bottom of the screen.
- It shows two station search fields:
  - origin, marked blue.
  - destination, marked green.
- Selecting either field opens the full-screen station selector.
- If both stations are selected, `MapScreen` calculates a route and the sheet switches to route mode.

## Focused Line Mode

Focused line mode exists so a user can tap a line number on the schematic and inspect every station on that line.

Behavior:

- The sheet opens as a `DraggableScrollableSheet`.
- Initial size is intentionally small so it does not cover too much map.
- Header shows a colored circular line number and localized line name.
- Close button clears focused-line state.
- The station list is ordered by `MetroLine.stationIds`.
- First and last stations receive stronger visual emphasis.
- The line marker column visually connects station rows.

This mode does not set origin or destination. It is a browsing mode only.

## Route Mode

When a route exists, the sheet becomes a `DraggableScrollableSheet`:

- initial size: 25% of screen height.
- minimum size: 25%.
- maximum size: 90%.
- snap enabled.

The route mode contains:

- Drag handle.
- Compact header with localized "from -> to".
- Close button that clears origin, destination, route, and line focus.
- Estimated travel time.
- Transfer count.
- Scrollable route timeline.

## Timeline Construction

The timeline is derived from `MetroRoute.segments`:

- Non-transfer segments render each station in order.
- Transfer segments render a walking-transfer row.
- Line color comes from `MetroData.getLine(segment.lineId)`.
- First and last stations in each metro segment get stronger visual emphasis.
- Intermediate stations remain visible so users can follow every stop.
- Every station row includes an info icon.
- Tapping the info icon opens `StationDetailScreen` instantly with no transition animation.

## Data Flow

```
MapScreen owns fromStation, toStation, currentRoute, focusedLineId
    |
    v
RouteDetailsSheet receives state and callbacks
    |
    v
No route: render search fields
Focused line: render all stations on selected line
Route: render summary and timeline
    |
    v
User selects stations, clears route, clears line focus, or opens station details
    |
    v
MapScreen or Navigator updates the visible state
```

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| Route is null and focused line is null | Search fields are shown |
| Route is null and focused line exists | Focused line sheet is shown |
| Route exists while line was focused | Route mode takes priority and line focus is cleared by selection flow |
| Focused line ID is unknown | Returns an empty widget |
| Route segment references missing line | Segment timeline returns an empty widget |
| Route segment references missing station | Missing station is skipped |
| Station names are long | Header and rows use ellipsis |
| Clear route pressed | Parent callback clears origin, destination, route, and focused line |

## Dependencies

- `MapScreen` owns all route and focused-line state.
- `StationSearchField` opens station selection.
- `MetroRoute` and `RouteSegment` provide route display structure.
- `MetroData` resolves station IDs, line colors, and line station order.
- `StationDetailScreen` displays station detail pages.
- `TranslationService` supplies labels, time text, transfer plurals, and current language.

## Known Limitations

- The transfer row label is still hardcoded and should be localized.
- The transfer row displays `~ 2 min` while route timing uses 3 minutes per transfer.
- The sheet does not show "no route available" if route calculation returns `null`.
- Focused line station rows are browse-only; tapping them does not set origin or destination.

## Future Considerations

- Localize all route timeline labels.
- Align displayed transfer duration with routing constants.
- Add per-segment stop counts or line names.
- Add station detail entry from focused line rows if useful.
- Add an explicit no-route state if future data can contain disconnected stations.
