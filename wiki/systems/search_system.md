# System: Station Search

## Overview

Lets users choose origin and destination stations by typing a station name, fully offline, using the app's built-in station data.

## How It Works

### Entry Points

Search is reached through the bottom route sheet:

- The "From" field opens a station selector for the origin.
- The "To" field opens a station selector for the destination.
- Each field shows the selected station name when set.

The field itself is not an inline text input. It is a tappable control that opens a full-screen station selector.

### Selector Flow

```
User taps From/To field
    |
    v
StationSearchField pushes StationSelector page
    |
    v
StationSelector shows search input and station list
    |
    v
User types query or scrolls full list
    |
    v
User taps station
    |
    v
Selection callback updates MapScreen state
    |
    v
Selector closes immediately
```

### Matching Rules

- Search is case-insensitive.
- Matching is substring-based.
- Matching uses the current app language only.
- If the query is empty, the selector shows all stations.
- The search system does not tokenize, transliterate, normalize accents, or search across every language at once.

Example:

- Current language is Russian.
- User types text.
- The app compares the query with each station's Russian display name.
- English-only spellings are not searched unless the current language resolves to English for that station.

### Rendering Rules

Each station result shows:

- A small colored dot based on the station's line.
- The station name in the current language.
- Heavier font weight if it is already selected.

The selector waits until the first frame before rendering the full list and requesting keyboard focus. This keeps the route sheet transition responsive and avoids making the map feel stuck during navigation.

## Data Flow

```
StationSelector initializes
    |
    v
Reads MetroData.allStations and MetroData.lines
    |
    v
User query changes
    |
    v
MetroData.searchStations(query, currentLanguage)
    |
    v
Filtered station list is rendered
    |
    v
Selected station returned through callback
```

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| Empty query | Shows all stations |
| No station matches | The filtered list is empty |
| Station has no name for current language | Station model falls back to English, then first available name |
| User selects the already selected station | Selection callback still fires and the selector closes |
| Keyboard focus happens before page is mounted | Focus request is delayed and guarded by `mounted` |

## Dependencies

- `MetroData.searchStations` for filtering.
- `Station.getLocalizedName` for language fallback.
- `TranslationService.currentLanguage` for active language.
- `StationSearchField` for opening the selector.
- `MapScreen` for applying the selected station and recalculating route when possible.

## Known Limitations

- No "no results" empty-state message is currently rendered even though translations exist.
- No recent searches are stored even though a translation key exists.
- No fuzzy matching, typo tolerance, transliteration, or multi-language search.
- The close icon inside a selected field currently calls the same selection callback with the selected station, so it does not truly clear the field by itself.

## Future Considerations

- Search across Russian, Czech, and English simultaneously.
- Add transliteration support for Cyrillic/Latin user input.
- Add an empty state using the existing `search.noResults` translation.
- Add recent station selections if it helps frequent commuters.
- Provide a true per-field clear action.
