# Feature: Route Planning

## Overview

Route planning is the user flow that turns two station selections into a highlighted metro route, readable bottom-sheet itinerary, and station-by-station detail entry points.

## Selection State

`MapScreen` owns four pieces of user-facing state:

- `fromStation`: origin station.
- `toStation`: destination station.
- `currentRoute`: calculated route, or null if no route is ready.
- `focusedLineId`: selected line badge, or null if no line is focused.

The map and bottom sheet receive this state and render the same selection consistently.

## Map Tap Flow

```
No stations selected
    |
    v
Tap station -> set origin
    |
    v
Tap different station -> set destination and calculate route
    |
    v
Tap another station while route exists -> start a new route from that station
```

Special behavior:

- Tapping the selected origin again before choosing a destination clears the origin.
- After a route exists, any station tap resets the flow and makes that station the new origin.
- Station selection clears focused-line mode because route building takes priority over line browsing.

## Search Flow

```
Tap From/To field
    |
    v
Select station in StationSelector
    |
    v
MapScreen sets origin or destination
    |
    v
If the other station is already selected, recalculate route
```

Search and map taps share the same state, so a user can mix both methods.

## Line Browsing Flow

```
Tap line-number badge
    |
    v
MapScreen toggles focusedLineId
    |
    v
Map dims other lines and stations
    |
    v
RouteDetailsSheet shows all stations on that line
```

Line browsing does not set origin or destination. It is cleared when the user starts choosing a route.

## Route Calculation Trigger

A route is calculated only when both stations are non-null:

- Setting origin while destination exists recalculates.
- Setting destination while origin exists recalculates.
- Selecting a destination from the map after origin exists calculates.

Clearing the selection removes:

- origin.
- destination.
- current route.
- focused line.

## Display Behavior

When a route exists:

- Metro map highlights route line segments.
- Non-route stations and lines become visually dimmed.
- Transfer walking segments appear as dashed connectors.
- Bottom sheet changes from station fields to route summary and timeline.
- Timeline station rows expose info icons that open station detail pages instantly.

When no route exists:

- Map shows the full network normally unless a line badge is focused.
- Bottom sheet shows station search fields.

When a line is focused:

- Map dims other lines and stations.
- Bottom sheet shows the focused line's complete station list.

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| User taps same station as origin before choosing destination | Origin is cleared |
| User chooses same origin and destination through search | Route service can return a zero-time route, though UI may enter route mode |
| Route service returns null | Current UI has no explicit no-route message |
| User clears route | Origin, destination, current route, and line focus are reset |
| User taps a station after route exists | Existing route is discarded and a new origin is selected |
| User taps a focused line badge again | Focused line is cleared |
| User starts route selection while line focused | Focused line is cleared |

## Dependencies

- `RouteService` for calculating route objects.
- `MetroMap` for station tap selection, line badge selection, and route highlighting.
- `RouteDetailsSheet` for search controls, focused line list, route summary, and clearing.
- `StationSelector` for search-based station selection.
- `StationDetailScreen` for route timeline info actions.

## Future Considerations

- Add a visible "no route available" state.
- Prevent same-station origin/destination from entering full route mode, or show a friendly "already here" message.
- Add swap origin/destination control.
- Allow focused line station rows to become route origins/destinations if useful.
- Add route alternatives once routing supports weighted preferences.
