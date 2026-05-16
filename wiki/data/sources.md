# Data Sources

## Overview

Station, line, coordinate, and station-detail data should be collected conservatively, cross-checked when possible, and documented with verification dates and confidence levels.

## Reliable Source Types

### Official Sources

| Source | URL | Reliability | What to Verify |
|--------|-----|-------------|----------------|
| Prague Public Transit Company | https://www.dpp.cz | High | Station names, current line status, official map |
| Prague Integrated Transport | https://pid.cz | High | Official transport and city information |
| Prague transport/news sources | varies | Medium-High | Opening dates, extensions, naming changes |

### International and Reference Sources

| Source | URL | Reliability | Notes |
|--------|-----|-------------|-------|
| Wikipedia EN | https://en.wikipedia.org/wiki/Prague_Metro | Medium-High | Useful starting point, verify dates and names |
| Wikipedia RU | https://ru.wikipedia.org/wiki/Ташкентский_метрополитен | Medium-High | Often more detailed for station pages |
| Wikidata | https://www.wikidata.org | Medium | Useful for coordinates and IDs, cross-check before use |
| UrbanRail.net | https://www.urbanrail.net/eu/cz/praha/prague.htm | Medium | Enthusiast-maintained network reference |

### Map and Local Directory Sources

| Source | URL | Reliability | Notes |
|--------|-----|-------------|-------|
| Mapy.cz | https://mapy.cz | Medium-High | Good for exits, addresses, local transport stops |
| OpenStreetMap | https://www.openstreetmap.org | Medium | Useful for coordinates, exits, nearby transport |
| OpenStreetMap | https://www.openstreetmap.org | Medium | Useful for embedded map coordinate checks |
| Mapcarta | https://mapcarta.com | Medium | Often wraps OSM/Wikidata coordinate data |

## Verification Strategy

1. **Cross-reference multiple sources** - Do not trust one source for important user-facing facts.
2. **Prefer official over unofficial** - Official maps and announcements are strongest for names and line status.
3. **Check dates** - Prague Metro has planned extensions and occasional service changes.
4. **Verify station names in multiple languages** - Czech names, Russian transliteration, and English usage can differ.
5. **Treat surface transport cautiously** - Bus routes and stop names can change.
6. **Keep confidence labels** - Use high, medium, or unknown instead of presenting all facts equally.

## Current Data Coverage

| Data Type | Current Status |
|-----------|----------------|
| Core station list | 50 stations in `MetroData` |
| Line assignments | Present for all stations |
| Schematic positions | Present for all stations |
| Transfer connections | Present for current route graph |
| Station detail records | Present for all 50 station IDs |
| Station coordinates | Present as coordinate strings in detail records |
| Nearby places | Present, but source quality varies |
| Exits | Partial; many stations still have no verified exits |
| Surface transport | Partial; bus data should be treated as change-prone |
| Train intervals | Not included because reliable public per-station data was not confirmed |
| Operating schedules | Not displayed in the current UI |

## Verification Log

| Data Point | Source(s) | Date Verified | Confidence |
|------------|-----------|---------------|------------|
| Station list | DPP map, PID, Wikipedia, user-collected station sets | 2026-05-06 | High |
| Station count (50) | Current app data | 2026-05-06 | High |
| Line colors | Official/metro maps and reference maps | 2026-05-04 | High |
| Transfer stations | Official map and app route graph review | 2026-05-06 | Medium |
| Station detail pages | Wikipedia, 2GIS, Yandex, Wikidata, Mapcarta, UrbanRail where available | 2026-05-05 to 2026-05-06 | Medium-High |
| Station coordinates | User-provided coordinate list cross-filled into detail data | 2026-05-06 | Medium-High |
| Train intervals | Public data not reliably confirmed | 2026-05-05 | Not included |

## Data Entry Rules

- Use stable station IDs that match `MetroData`.
- Keep coordinates as `latitude, longitude` until typed coordinate fields are introduced.
- Add a `verifiedDate` for every station detail record.
- Add sources even when confidence is medium.
- Prefer omitting uncertain bus routes or marking them as unverified in notes.
- Do not invent schedules or intervals.

## Known Data Gaps

- Exact exit locations for many stations.
- Real-time or current bus routes near many stations.
- Accessibility data.
- Entrance-level coordinates.
- Official per-station operating times.
- Clean UTF-8 normalization for all localized source strings.

## Future Considerations

- Build a validation script for station detail coverage, coordinates, source URLs, and translation keys.
- Store station detail data in JSON once maintenance grows.
- Add release-level data versioning.
- Add a "last verified" note in app UI if users need transparency.

---

**Note**: When in doubt, default to conservative data. It is better to omit uncertain info than show wrong info.
