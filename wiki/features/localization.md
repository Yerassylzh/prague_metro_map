# Feature: Localization

## Overview

Localization provides app text, line names, station names, and station detail content in English, Russian, and Czech from bundled offline assets and in-memory data.

## Supported Languages

The app currently supports:

| Code | Language |
|------|----------|
| `en` | English |
| `ru` | Russian |
| `cs` | Czech |

## Startup Language Flow

```
main()
    |
    v
Read saved language from SharedPreferences
    |
    v
Load assets/env.json
    |
    v
Load translation JSON for saved language, or English if no language is saved
    |
    v
If no saved language exists, show LanguageSelectionScreen
Otherwise show MapScreen
```

First launch behavior:

- If no language code is saved, the language selection page opens first.
- Selecting a language saves it through `LanguagePreferenceService`.
- The selected JSON file is loaded immediately.
- The app switches to the map without requiring restart.

## App Text

Translations are stored as JSON assets:

- `assets/translations/en.json`
- `assets/translations/ru.json`
- `assets/translations/cs.json`

Translation keys are dot-separated paths. Example:

```
route.time -> route -> time
```

If a key cannot be found, the key itself is returned. This makes missing translations visible instead of failing silently.

## Singleton Service

`TranslationService` is a singleton:

- All callers share the current language and translation map.
- `loadTranslations(languageCode)` replaces the current language and JSON map.
- `currentLanguage` is read by search, map labels, route details, station details, and feedback screens.

`MaterialApp` is keyed by the current language. This forces the app tree to rebuild after language selection.

## Parameter Interpolation

Translation strings can include placeholders:

```
{minutes} min
```

Callers pass a parameter map, and each `{key}` is replaced with its value.

## Pluralization

Plural keys are generated from a base key and count.

Russian:

- `_one` for counts ending in 1 except 11.
- `_few` for counts ending in 2, 3, or 4 except 12-14.
- `_many` for all other counts.

Other languages:

- `_zero` for 0.
- `_one` for 1.
- `_other` for everything else.

## Station, Line, and Detail Names

Station names live on each `Station` record as localized maps.

Line names live on each `MetroLine` record as localized maps.

Station detail text uses localized maps in `station_details_data.dart`.

Fallback order:

1. Requested language.
2. English.
3. First available value.

This fallback keeps the app usable even when a station detail has incomplete Czech or Russian text.

## Localized UI Areas

Localization now covers:

- Search fields and station selector.
- Route summary text.
- Transfer labels in the route timeline.
- Map station labels.
- Line names in bottom sheets and headers.
- Station detail section titles and content.
- Embedded station map missing-coordinate message.
- Feedback page text and rate prompt copy.
- Settings-page language selection.

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| Missing translation key | Returns the key string |
| Non-string translation value requested | Returns the key string |
| Missing interpolation param | Placeholder remains in the result |
| Missing station or line language | Falls back to English, then first available name |
| Missing station detail language | Falls back to English, then first available value |
| No saved language | First-launch language selection is shown |
| User changes language in settings | Preference is saved, translations reload, and listening screens rebuild |

## Dependencies

- Translation JSON assets declared in `pubspec.yaml`.
- `shared_preferences` for saved language code.
- `TranslationService` for app text and current language.
- `LanguagePreferenceService` for persistence.
- `Station.getLocalizedName`, `MetroLine.getLocalizedName`, and `localizedText`.

## Known Limitations

- Some source strings in the repository still show mojibake and should be normalized to UTF-8.
- Search uses the active language only; it does not search across all languages at once.
- Language selection screen labels are currently hardcoded rather than translated.

## Future Considerations

- Add automated checks for missing keys across translation files.
- Add transliteration-aware search for Russian and Czech station names.
- Normalize text encoding across source files and wiki docs.
