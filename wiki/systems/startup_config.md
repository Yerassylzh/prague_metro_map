# System: Startup and App Configuration

## Overview

Startup loads persisted user preferences, bundled environment configuration, and translations before deciding whether to show language selection or the main map.

## Startup Flow

```
main()
    |
    v
WidgetsFlutterBinding.ensureInitialized()
    |
    v
LanguagePreferenceService.getSavedLanguageCode()
    |
    v
AppConfigService.load()
    |
    v
TranslationService.loadTranslations(savedLanguageCode ?? "en")
    |
    v
runApp(PragueMetroApp(showLanguageSelection: savedLanguageCode == null))
```

## Persisted Preferences

The app uses `shared_preferences` for small local state:

| Key | Owner | Meaning |
|-----|-------|---------|
| `language_code` | `LanguagePreferenceService` | User's selected app language |
| `rate_prompt_launch_count` | `RatePromptService` | Number of counted app foreground opens |
| `rate_prompt_last_shown_launch_v2` | `RatePromptService` | Launch count when rate prompt was last shown |
| `rate_prompt_completed_v2` | `RatePromptService` | Whether the user opened the store review page |

These values remain on the device until app data is cleared or the app is uninstalled.

## Environment Config

Runtime-like config is bundled as an asset:

```
assets/env.json
```

Current fields:

| Field | Meaning |
|-------|---------|
| `privacy_policy_url` | Browser URL opened from the feedback page |
| `support_email` | Email address used by the "write to us" action |
| `admob_top_banner_ad_unit_id` | AdMob banner ad unit ID for the main map top banner |
| `admob_station_info_interstitial_ad_unit_id` | AdMob interstitial ad unit ID for station detail view cadence |

`AppConfigService` loads this file before `runApp`.

Failure behavior:

- If the asset is missing, malformed, or unreadable, config values fall back to empty strings.
- Empty config values cause the relevant feedback actions to show an unavailable snackbar instead of crashing.

## First-Launch Language Decision

- If `language_code` exists, the app loads that language and goes directly to `MapScreen`.
- If `language_code` does not exist, the app loads English first and shows `LanguageSelectionScreen`.
- When the user selects a language, it is saved and the selected translations are loaded immediately.

## Data Flow

```
SharedPreferences + assets/env.json + assets/translations/*.json
    |
    v
LanguagePreferenceService, AppConfigService, TranslationService
    |
    v
PragueMetroApp decides initial screen
    |
    v
Map, station details, feedback, and native intents use loaded values
```

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| No saved language | Show language selection |
| Saved language file is missing | Startup translation load can fail; should be guarded in future |
| `assets/env.json` missing | Config defaults to empty strings |
| Privacy URL empty | Privacy action shows unavailable snackbar |
| Support email empty | Email action shows unavailable snackbar |
| Banner ad unit ID empty | Ad banner falls back to Google test banner unit ID |
| Interstitial ad unit ID empty | Station info interstitial falls back to Google test interstitial unit ID |
| App is resumed from background | Rate prompt can count the foreground open |

## Dependencies

- `shared_preferences` for persisted local values.
- Flutter asset bundling for translations and `assets/env.json`.
- `TranslationService` for startup language load.
- `AppConfigService` for support/privacy config.
- `RatePromptService` for foreground-open counting.

## Known Limitations

- Root-level `env.json` is not used by the app; the bundled file is `assets/env.json`.
- Translation loading is not currently wrapped in the same fallback protection as config loading.
- There is no visible settings UI for resetting preferences or changing language after first launch.

## Future Considerations

- Add validation for required config fields during development builds.
- Add a settings screen for language changes.
- Consider making translation loading fall back to English if a saved language asset is missing.
- Add app versioned migrations for preference keys if behavior changes again.
