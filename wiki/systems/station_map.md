# System: Embedded Station Map

## Overview

The embedded station map opens an in-app map centered on a station's geographic coordinates without redirecting the user to another map application.

## Why This Exists

The earlier external-map approach was rejected because it redirected out of the app. The current approach keeps users inside the app and provides a normal back button through Flutter navigation.

## How It Works

1. User opens a station detail page.
2. User taps "Open in map".
3. `StationMapScreen` receives the current `Station` and its `StationDetail`.
4. The screen parses `StationDetail.coordinates`.
5. If parsing succeeds, `flutter_map` renders an OpenStreetMap tile view centered on the station.
6. A marker shows the localized station name.
7. If parsing fails or coordinates are missing, the page shows a localized missing-coordinate message.

## Coordinate Format

Coordinates are stored as a simple string in station details:

```
41.326700, 69.334076
```

Parsing rules:

- First number is latitude.
- Second number is longitude.
- Spaces around the comma are allowed.
- Negative values are accepted by the parser.
- Any surrounding source text is ignored if the regex can find the first coordinate pair.

## Map Behavior

| Setting | Value |
|---------|-------|
| Tile package | `flutter_map` |
| Coordinate type | `latlong2.LatLng` |
| Tile source | `https://tile.openstreetmap.org/{z}/{x}/{y}.png` |
| Initial zoom | 16 |
| Minimum zoom | 11 |
| Maximum zoom | 19 |
| Marker | Localized station label plus red location icon |

The map is intentionally simple and lightweight:

- No routing.
- No search.
- No live location.
- No external app redirect.
- No map SDK key.

## Data Flow

```
StationDetailScreen
    |
    v
StationMapScreen(station, details)
    |
    v
StationCoordinates.tryParse(details.coordinates)
    |
    +-- null -> missing-coordinate message
    |
    v
FlutterMap centered on LatLng
    |
    v
OpenStreetMap tiles + station marker
```

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| Coordinate string is null | Show missing-coordinate message |
| Coordinate string is malformed | Show missing-coordinate message |
| Station or line name is long | Header and marker text ellipsize |
| Device has no internet | Screen opens, but OSM tiles may not load |
| OSM tile server is unavailable | Map area may be blank or partially loaded |

## Dependencies

- `flutter_map` for map rendering.
- `latlong2` for coordinate objects.
- Android `INTERNET` permission for tile loading.
- `StationDetail.coordinates` for the coordinate source.
- `TranslationService` for localized labels and missing-coordinate text.

## Offline Boundary

This is the one user-facing map feature that is not fully offline. The app shell and marker are local, but map tiles are loaded from OpenStreetMap over the network.

## Future Considerations

- Add tile caching if offline station maps become important.
- Store coordinates as typed latitude/longitude fields instead of parseable strings.
- Add entrance-level markers if entrance coordinates are collected.
- Add attribution UI if the map view becomes more prominent.
