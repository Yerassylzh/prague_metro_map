# Feature: Ads

## Overview

Ads are integrated with Google AdMob, with banner placements plus a conservative station-info interstitial cadence.

## Current Implementation

The app currently uses two banner placements:

| Placement | Screen | Behavior |
|-----------|--------|----------|
| Top banner | Main map screen | Loads above the map area and below the status bar |
| Bottom banner | Settings / feedback screen | Stays pinned below the scrollable settings content |
| Bottom banner | Station detail screen | Stays pinned below station information content |

Interstitial placement:

| Placement | Trigger | Behavior |
|-----------|---------|----------|
| Station info interstitial | Every 3 completed station detail views | Shows after the user returns from the station detail page, if an ad is loaded |
| Route clear interstitial | Every 5 completed route clears | Shows after the user clears an existing route, if an ad is loaded |

The previous main-screen header was removed so the ad does not compete with header content or shrink the map twice.

## Banner Size

The banners use an anchored adaptive banner size:

- Width is based on the current screen width.
- Height is chosen by the Google Mobile Ads SDK.
- Height is at least 50 px and capped by the SDK for the current orientation.
- The ad is centered inside a reserved 100 px slot.
- If the ad fails to load, the 100 px slot remains visible with a quiet placeholder frame.

This is preferable to a fixed 320x50 banner because it adapts to different phone widths while still behaving like a stable top banner.

## Config

AdMob has two IDs:

| ID Type | Location | Current Value |
|---------|----------|---------------|
| Android app ID | `AndroidManifest.xml` meta-data | Google test app ID |
| Banner ad unit ID | `assets/env.json` | Google test banner unit ID |
| Station info interstitial ad unit ID | `assets/env.json` | Google test interstitial unit ID |

The root `env.json` is kept in sync for editing convenience, but the app loads `assets/env.json`.

Production release checklist:

- Replace Android AdMob app ID in `android/app/src/main/AndroidManifest.xml`.
- Replace `admob_top_banner_ad_unit_id` in `assets/env.json`.
- Replace `admob_station_info_interstitial_ad_unit_id` in `assets/env.json`.
- Do not ship Google test ad unit IDs in production.

## Startup Flow

```
main()
    |
    v
Load AppConfigService from assets/env.json
    |
    v
Initialize MobileAds
    |
    v
MapScreen renders TopAdBanner
FeedbackScreen renders BottomAdBanner
StationDetailScreen renders BottomAdBanner
InterstitialAdService preloads one shared interstitial
```

## Banner Loading Flow

```

## Station Info Interstitial Flow

```
App startup
    |
    v
InterstitialAdService preloads one interstitial
    |
    v
User opens a station detail page from route timeline
    |
    v
User returns from station detail page
    |
    v
Increment persistent station_info_view_count
    |
    +-- count not divisible by 3 -> preload if needed, show nothing
    |
    +-- count divisible by 3 and ad ready -> show interstitial
    |
    +-- count divisible by 3 and ad not ready -> preload, show nothing
```

This timing intentionally avoids blocking the station information page itself.

## Route Clear Interstitial Flow

```
User builds a route
    |
    v
User presses clear on the route sheet
    |
    v
MapScreen clears route state
    |
    v
Increment persistent cleared_route_count
    |
    +-- count not divisible by 5 -> preload if needed, show nothing
    |
    +-- count divisible by 5 and ad ready -> show interstitial
    |
    +-- count divisible by 5 and ad not ready -> preload, show nothing
```

This timing keeps ads after a completed route workflow rather than during station selection or route calculation.
AdBanner mounted
    |
    v
Read screen width
    |
    v
Ask SDK for anchored adaptive banner size
    |
    v
Create BannerAd using configured ad unit ID
    |
    +-- loaded -> render AdWidget at SDK size
    |
    +-- failed -> dispose ad and render nothing
```

## Layout Rules

- The map banner sits outside the map's inner `Stack`.
- Floating review/settings buttons sit inside the map area, below the banner.
- The route details sheet still draws above the floating buttons.
- The map remains usable if the ad does not load.
- The settings banner sits outside the scrollable content and remains pinned at the bottom.
- The station detail banner sits in `Scaffold.bottomNavigationBar`, so station information scrolls above it.

## Dependencies

- `google_mobile_ads`.
- Android `INTERNET` permission.
- Android AdMob app ID meta-data.
- `AppConfigService` for banner unit ID.

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| Ad fails to load | 100 px slot remains visible with a quiet placeholder frame |
| Ad unit ID missing | Falls back to Google Android test banner ID |
| Interstitial unit ID missing | Falls back to Google Android test interstitial ID |
| 3rd station info view but interstitial not loaded | No ad is shown; next interstitial is preloaded |
| 5th route clear but interstitial not loaded | No ad is shown; next interstitial is preloaded |
| Device rotates | Current implementation does not force reload after rotation |
| Running outside Android/iOS | Google Mobile Ads support may be limited |

## Future Considerations

- Add explicit development vs production config.
- Add ad loading logs only in debug builds if troubleshooting is needed.
- Consider reloading adaptive banner on orientation/width changes.
- Add a per-session cap if station info browsing becomes ad-heavy.
