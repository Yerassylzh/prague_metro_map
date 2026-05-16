# Project Vision: Prague Metro Offline

## Vision

Create a simple, fast, mostly offline metro navigation app for Prague that helps users understand routes, explore stations, and move around the city with minimal friction.

The app should feel clean, modern, and intuitive: something a tourist or local can open and understand quickly.

## Core Idea

A user opens the app, taps two stations, and immediately sees a route highlighted on a clear schematic metro map.

## Main Features

### 1. Interactive Metro Map

- Show the full Prague metro as a clean schematic map.
- Stations are visible and easy to tap.
- User can zoom and move around the map.
- Line-number badges let users inspect a full line.
- The map should look modern and easy to read.

### 2. Route Creation

- User taps one station to select a starting point.
- User taps another station to build a route automatically.
- The route is visually highlighted on the map.
- Other lines and stations become faded so the route is clear.
- Show estimated travel time and number of transfers.
- Route timeline exposes station info buttons.

### 3. Search

- User can search stations using text.
- Support English, Russian, and Czech station names.
- Selecting stations from search builds a route instantly when both endpoints are known.

### 4. Station Information

Each station has its own info page.

Show:

- Station name.
- Line.
- Exits when known.
- Nearby places.
- Nearby surface transport when known.
- Notes, verification date, confidence, and sources.
- Coordinates when known.
- Embedded station map button.

Schedule and interval data should not be guessed. If reliable public data is unavailable, omit it.

### 5. Offline-First Experience

The core transit experience should work without internet:

- Schematic metro map.
- Station search.
- Route calculation.
- Route timeline.
- Station detail text.
- Language selection and translations.

Some secondary features can require network or another installed app:

- Embedded map tiles.
- Privacy policy link.
- Email support.
- Google Play review link.

### 6. Simple and Lightweight

- Keep dependencies limited.
- Avoid heavy map SDKs unless truly needed.
- Prefer bundled data over runtime services for the main metro experience.
- Focus on common user needs.

## User Experience

Expected happy path:

```
Open app -> choose language if first launch -> see metro map
    -> tap station -> tap station -> get route
    -> expand route -> inspect stations if needed
```

## Design Direction

- Minimal and modern.
- Shared blue app header.
- Clear metro line colors.
- Smooth route highlighting.
- Compact controls that do not cover too much of the map.
- Focus on clarity over decoration.

## Success Criteria

- User can build a route in under 5 seconds.
- Core app works without internet.
- Station information opens instantly.
- Interface feels simple and clear on first use.
- Secondary actions fail gracefully when a browser, mail app, Play Store, or internet is unavailable.

## Future Potential

- Add language switching after first launch.
- Add richer verified station exits and accessibility data.
- Add offline tile caching if embedded maps become important offline.
- Add more cities later if the data model is generalized.
- Add real-time data only if it does not weaken the offline-first experience.
