# System: Metro Data

## Overview

Metro Data provides the app's offline source of truth for schematic metro lines, station records, route graph order, transfer connections, translated names, and map rendering paths.

## How Data is Organized

Metro data currently lives in code as static Dart structures. There is no runtime JSON loader or repository layer yet.

The broader data system is split into two layers:

| Layer | File | Purpose |
|-------|------|---------|
| Core network data | `lib/data/metro_data.dart` | Lines, station IDs, schematic positions, transfer links, rendering paths |
| Station detail data | `lib/data/station_details_data.dart` | Exits, nearby places, transport notes, coordinates, sources, confidence |

This split keeps routing and rendering data small while allowing station detail records to be richer.

## Lines

Each line contains:

- `id`: stable key used by routing, rendering, and translations.
- `number`: user-facing metro line number.
- `name`: localized display names.
- `color`: the line color used by the map and station list.
- `stationIds`: ordered station IDs used for routing adjacency.
- `path`: visual path nodes used by the painter.

The app currently models four lines:

| Line ID | Color | Routing Shape | Notes |
|---------|-------|---------------|-------|
| `line_a` | Green | Linear | Nemocnice Motol to Depo Hostivař |
| `line_b` | Yellow | Linear | Zličín to Černý Most |
| `line_c` | Red | Linear | Letňany to Háje |

## Stations

Each station contains:

- `id`: stable unique identifier.
- `name`: map of language code to station name.
- `lineId`: line membership.
- `x` and `y`: normalized schematic coordinates.
- `transferTo`: station IDs that can be reached by walking transfer.

Important assumption:

- Transfers between lines are represented as separate station records linked by `transferTo`, even when the displayed physical interchange feels like one station complex.

## Station Detail Records

Station detail records are keyed by the same station IDs used in core metro data.

The detail dataset now contains records for all current station IDs and includes coordinate strings for embedded map display.

Detail records intentionally live outside `Station` to avoid making route/search/map objects heavy.

## Visual Paths

Line paths are separate from line station order:

- `stationIds` answers "which stations are neighbors for routing?"
- `path` answers "what shape should the line take on the map?"
- `PathNode.station(id)` anchors the path to a station coordinate.
- `PathNode.point(x, y)` adds a bend point that has no station and no routing meaning.

This separation lets the app draw clean schematic bends without inventing fake stations in the route graph.

## Query Methods

`MetroData` exposes simple static helpers:

| Method | Purpose |
|--------|---------|
| `getStation(id)` | Look up one station by ID |
| `getLine(id)` | Find one line by ID |
| `getStationsOnLine(lineId)` | Return ordered station objects on a line |
| `allStations` | Return all station objects |
| `searchStations(query, languageCode)` | Case-insensitive substring search in one language |

## Data Flow

```
Static MetroData definitions
    |
    +-- RouteService uses stationIds and transferTo
    +-- MetroMapPainter uses path, coordinates, colors, and transfers
    +-- MetroMap uses station positions, labels, and line badges
    +-- Search UI uses allStations and localized names
    +-- Route details resolves station IDs back to station names

Station details data
    |
    +-- StationDetailScreen renders station facts and sources
    +-- StationMapScreen parses coordinates for embedded map
```

## Edge Cases

| Scenario | Handling |
|----------|----------|
| Station has no requested language name | Falls back to English, then first available name |
| Detail text has no requested language | Falls back to English, then first available value |
| Line ID is unknown | Query returns `null` or empty list |
| Station ID in a line is missing from station map | Filtered out in station-list queries; skipped in rendering |
| Transfer listed on one side only | Routing works in the listed direction only; transfer data should be symmetric |
| Path contains a bend point | Painter draws it; routing ignores it |
| Circle line expected to loop | Current routing does not connect last station back to first unless an explicit edge is added |
| Detail coordinates malformed | Embedded station map shows missing-coordinate message |

## Data Quality Notes

- Current network data contains 50 station records.
- Current station detail data contains records for all 50 station IDs.
- Schedule and interval data are not shown because public reliable per-station interval data was not confirmed.
- Some source text in the repository still appears mojibake-encoded and should be normalized to UTF-8.

## Dependencies

- `Station` defines core station structure.
- `MetroLine` and `PathNode` define routing order and visual line shape.
- `StationDetail`, `StationExit`, and `NearbyTransport` define station detail structure.
- `RouteService`, `MetroMap`, `MetroMapPainter`, station search, route details, station details, and embedded maps all depend on this data.

## Future Considerations

- Move static data to JSON or another structured asset once editing and validation become more important.
- Add validation for every line station ID, transfer target, symmetric transfer pair, detail record, coordinate format, and required language name.
- Add a data version and verification date in the app-visible dataset.
- Normalize all localized text to clean UTF-8.
