# System: Station Details

## Overview

Station Details displays offline station-specific information from the curated station detail dataset and gives users an instant route-timeline entry point into each station page.

## Current Implementation Status

Station details are implemented as:

- A standalone model in `lib/models/station_detail.dart`.
- A curated in-memory data table in `lib/data/station_details_data.dart`.
- A reusable section widget in `lib/widgets/station_detail_section.dart`.
- A screen in `lib/screens/station_detail_screen.dart`.
- Info buttons in the route details timeline.

The old `Station.details` model path is no longer the main detail source. The app now looks up detail records by station ID in the `stationDetails` map.

## Detail Data Model

Each station detail record can contain:

| Field | Meaning |
|-------|---------|
| `exits` | Exit location plus explanatory details |
| `nearbyPlaces` | Interesting, cultural, commercial, or practical nearby places |
| `nearbyTransport` | Buses, trolleybuses, trams, and free-form transport notes |
| `coordinates` | A parseable `latitude, longitude` string used by the embedded map |
| `notes` | Historical, architectural, naming, transfer, or verification notes |
| `sources` | URLs used while collecting the record |
| `verifiedDate` | Date when the record was last checked |
| `confidence` | Localized confidence label such as high, medium, or unknown |

Most human-readable fields are localized maps:

```
{ "en": "...", "ru": "...", "cs": "..." }
```

Fallback order for localized detail text:

1. Active app language.
2. English.
3. First available value.

## How It Works

1. A route is calculated.
2. The route sheet renders each route station row.
3. Each row has an info icon.
4. Tapping the icon opens `StationDetailScreen` with zero-duration page transition.
5. The screen resolves:
   - station name from `Station.getLocalizedName`.
   - line name from `MetroData.getLine`.
   - detail record from `stationDetails[station.id]`.
6. Empty or missing sections are either hidden or replaced with an explicit missing-data message.
7. Source metadata is shown at the bottom so uncertain data remains traceable.
8. A bottom banner ad is pinned below the detail content.

## Display Rules

- The header uses the shared blue app header color.
- The title is the localized station name.
- The subtitle is the localized line name and line number.
- "Open in map" is always shown, but the destination map page handles missing coordinates.
- Nearby places are hidden when empty.
- Exits show a missing-data message when no exit records exist.
- Surface transport shows available bus/trolleybus/tram/other entries, or a missing-data message.
- Notes are shown as a simple bullet-style list.
- Coordinates are shown only when present.
- Source confidence, verification date, and source URLs are always shown for the detail record.
- The bottom ad is outside the scrollable detail list, so content scrolls above it.

## Data Flow

```
Route timeline station row
    |
    v
Info icon tapped
    |
    v
StationDetailScreen(station)
    |
    v
stationDetails[station.id] or StationDetail.fallback
    |
    v
Localized sections rendered
    |
    v
Optional embedded map opened from coordinates
```

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| Detail record is missing | Uses `StationDetail.fallback` |
| Detail text lacks active language | Falls back to English, then first available value |
| Nearby places are empty | Section is hidden |
| Exits are empty | Section shows explicit missing-data text |
| Transport is empty | Section shows explicit missing-data text |
| Coordinates are missing | Detail page still opens; embedded map page shows missing-coordinate message |
| Source confidence is unknown | Fallback confidence label is used |

## Dependencies

- `MetroData` for station and line lookup.
- `stationDetails` for station-specific records.
- `TranslationService` for section titles and current language.
- `StationDetailSection` and related text helpers for visual consistency.
- `StationMapScreen` for embedded coordinate viewing.

## Data Quality Notes

- Train intervals were intentionally removed because reliable public interval data was not available.
- Schedule fields from collected JSON are not represented in the current UI.
- Some exit and bus data is still sparse or source-limited.
- Every station now has a coordinate string in the detail dataset, but coordinate accuracy depends on the source used.

## Future Considerations

- Move station detail data to JSON when manual editing becomes painful.
- Add automated validation for missing station IDs, malformed coordinates, and missing translations.
- Add accessibility, platform depth, entrance coordinates, and official operating hours only when reliable data exists.
- Make source URLs tappable if needed.
