# Documenting Rules for Prague Metro App

## Purpose

This document establishes guidelines for documenting systems and features during development. The goal is to capture the "under the hood" logic, decision-making, and operational details, not to paste implementation code.

## Core Principles

1. **Focus on "How It Works"** - Explain the logic, rules, and behaviors.
2. **Less Code, More Logic** - Avoid code dumps; describe what the code does and why.
3. **Preserve Context for AI** - Document so future AI assistants can understand without guessing.
4. **Living Documentation** - Update docs whenever systems evolve.

## What to Document

### For Each Major System or Feature

| Section | What to Include |
|---------|-----------------|
| **Overview** | What this system does and why it exists |
| **How It Works** | Step-by-step logic, rules, and decision paths |
| **Data Flow** | What data comes in, how it is processed, what goes out |
| **Edge Cases** | Special scenarios and how they are handled |
| **Dependencies** | Other systems, assets, packages, or platform behavior it relies on |
| **Future Considerations** | Known limitations or likely improvements |

## Documentation Structure

```
wiki/
|-- documenting_rules.md (this file)
|-- VISION.md (project vision)
|-- systems/
|   |-- metro_data.md (stations, lines, connections)
|   |-- routing_engine.md (route calculation logic)
|   |-- map_rendering.md (how map is drawn and interacted with)
|   |-- search_system.md (search indexing and matching)
|   |-- route_details_sheet.md (route and line bottom sheet behavior)
|   |-- station_details.md (station detail data and UI)
|   |-- station_map.md (embedded station map behavior)
|   |-- startup_config.md (startup, config, persisted preferences)
|-- features/
|   |-- route_planning.md (user flow for building routes)
|   |-- offline_mode.md (what works offline and what needs network)
|   |-- localization.md (translation system)
|   |-- feedback_and_review.md (feedback page, native intents, rating prompt)
|   |-- ads.md (AdMob placements and config)
|-- data/
|   |-- sources.md (where data comes from, verification)
```

## Writing Guidelines

1. **Start with a one-sentence summary** - What this system does.
2. **Use bullet points** for rules and logic steps.
3. **Include examples** when explaining complex logic.
4. **Call out assumptions** explicitly.
5. **Use diagrams** with ASCII or Mermaid when helpful.

## Example Format

```markdown
# System: Route Calculation

## Overview

Determines an optimal metro route between two stations.

## How It Works

1. **Find Path**
   - Use graph search to find a station path.
   - Same-line neighbors come from line station order.
   - Transfers come from explicit transfer links.

2. **Calculate Time**
   - Station-to-station: fixed average.
   - Transfer: fixed walking/waiting allowance.

3. **Generate Display**
   - Highlight active route lines.
   - Dim non-route lines.
   - Show transfer rows in the route sheet.

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| Same station selected | Return zero-time route or show friendly state |
| No connection possible | Show no route state |

## Dependencies

- Metro graph data.
- Station and line models.
- Route details UI.
```

## Review Checklist

Before marking documentation complete:

- [ ] Can a new developer understand how the system works without reading code?
- [ ] Are all edge cases described?
- [ ] Are data sources noted?
- [ ] Is every magic number or hardcoded value explained?
- [ ] Would an AI assistant be able to maintain or extend this?

---

**Remember**: Documentation is for understanding. When in doubt, explain more.
