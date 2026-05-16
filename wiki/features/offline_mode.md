# Feature: Offline Mode

## Overview

The core metro app works offline by bundling station data, translations, schematic rendering, search, route planning, and station details inside the Flutter application.

## What Works Offline

No network request is required for:

- Opening the main schematic metro map.
- Viewing all station and line labels.
- Selecting origin and destination stations.
- Searching stations.
- Calculating routes.
- Viewing the route timeline.
- Opening station detail pages.
- Reading station exits, nearby places, transport notes, coordinates, sources, and confidence.
- Choosing first-launch language after translation assets are bundled.
- Showing the feedback page UI.
- Showing the rate prompt UI.

## What Needs Network or Another App

| Feature | Requirement |
|---------|-------------|
| AdMob banner | Internet access to Google ad services |
| Embedded station map tiles | Internet access to OpenStreetMap tile server |
| Privacy policy | Browser and internet access |
| Email support | Installed mail app; internet depends on mail provider |
| Google Play rating | Play Store app or browser; internet access |

The app intentionally keeps the main transit experience offline even though a few secondary actions leave the offline boundary.

## Offline Assets

The app currently depends on local assets and code:

- Static station and line data in `MetroData`.
- Station detail records in `station_details_data.dart`.
- Translation JSON files under `assets/translations`.
- GIF animations under `assets/animations`.
- Config in `assets/env.json`.
- Map rendering through Flutter widgets and custom painting.
- Routing through local in-memory graph search.

## Startup Flow

```
App starts
    |
    v
Flutter binding initializes
    |
    v
Saved language is read from SharedPreferences
    |
    v
Config and translation assets are loaded from bundle
    |
    v
Language selection or MapScreen opens
```

## Data Flow

```
Bundled app code and assets
    |
    v
TranslationService + MetroData + stationDetails
    |
    v
Map, search, route calculation, route details, and station details
```

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| Device has no internet | Core metro map, search, routing, and station details still work |
| OSM tiles unavailable | Embedded station map screen opens but tiles may not load |
| Translation asset missing | Startup translation load can fail; future fallback needed |
| Config asset missing | Config values default to empty strings |
| Metro data is outdated | App continues working but may show stale routes or details |
| User clears app data | Saved language and rate prompt counters reset |

## Dependencies

- Flutter asset bundling.
- Static Dart data structures.
- Local JSON translation files.
- `shared_preferences` for language and prompt state.
- `flutter_map` only for the online tile-based station map.
- `google_mobile_ads` only for ad placements.
- Android intents for secondary feedback actions.

## Known Limitations

- There is no data update mechanism inside the app.
- There is no offline tile cache for embedded station maps.
- There is no automated data freshness warning.
- Config is bundled and cannot be changed remotely after release.

## Future Considerations

- Add app data versioning so users and developers know how current the metro data is.
- Add a manual data verification log tied to releases.
- Add optional cached map tiles for station maps if licensing and storage constraints are acceptable.
- If online updates are ever added, keep bundled data as a guaranteed fallback.
