# Feature: Feedback and Review

## Overview

Feedback and review features let users contact support, open the privacy policy, open the Google Play listing, and receive a periodic "Rate us" prompt.

## Entry Points

| Entry Point | Location | Action |
|-------------|----------|--------|
| Left floating map button | Top-left of map | Opens Google Play / market listing |
| Right floating map button | Top-right of map | Opens settings / feedback screen |
| Feedback "Write to us" | Feedback screen | Opens Android mail app |
| Feedback rating block | Feedback screen | Opens Google Play / market listing |
| Feedback privacy policy | Feedback screen | Opens browser URL from config |
| Periodic popup | Main map foreground opens | Asks user to rate app |

## Feedback Screen

The settings / feedback page is intentionally simple and similar to the reference design:

- Back button at top.
- Contact prompt with "write to us".
- Share-app prompt text.
- Clickable rating block with `rating5.gif`.
- Privacy policy link.
- Language selector at the bottom.
- Pinned bottom banner ad.

The current page intentionally keeps only feedback, share, rating, and privacy actions.

## Native Android Bridge

Flutter calls Android through a method channel:

```
prague_metro_map/app_review
```

Supported methods:

| Method | Android behavior |
|--------|------------------|
| `openStoreReview` | Opens `market://details?id=<packageName>` and falls back to Google Play web URL |
| `openUrl` | Opens a browser with the provided URL |
| `sendEmail` | Opens an email app using a `mailto:` URI |

Every Flutter call returns a boolean:

- `true`: Android accepted and launched an intent.
- `false`: no matching app, missing plugin, platform exception, or blank input.

The UI shows a localized snackbar when an action cannot be opened.

## Config

The feedback system reads:

- `privacy_policy_url` from `assets/env.json`.
- `support_email` from `assets/env.json`.

If either value is empty, the related action fails safely and shows an unavailable message.

## Rate Prompt Logic

The periodic popup is managed by `RatePromptService`.

Persistence keys:

| Key | Meaning |
|-----|---------|
| `rate_prompt_launch_count` | Counted app foreground opens |
| `rate_prompt_last_shown_launch_v2` | Last launch count where popup appeared |
| `rate_prompt_completed_v2` | User opened the store review page |

Rules:

1. If `rate_prompt_completed_v2` is true, never show the popup again.
2. Every checked foreground open increments `rate_prompt_launch_count`.
3. Do not show before 7 counted opens.
4. Show only if at least 7 opens have passed since the last prompt.
5. When the popup is shown, save the current launch count as `rate_prompt_last_shown_launch_v2`.
6. If the user cancels, the prompt waits another 7 opens.
7. If the user taps the rate action and the store opens successfully, set `rate_prompt_completed_v2` to true.

The same completion key is also set when the user opens the store listing from the floating review button or feedback rating block.

## Lifecycle Counting

`MapScreen` observes app lifecycle events:

- First frame after `MapScreen` creation checks the prompt.
- Returning to foreground with `AppLifecycleState.resumed` also checks the prompt.
- A local `_isRatePromptVisible` guard prevents duplicate dialogs and accidental double-counting from overlapping checks.

This means normal cold starts and background-to-foreground opens can both count.

## Data Flow

```
MapScreen lifecycle
    |
    v
RatePromptService.shouldShowPrompt()
    |
    +-- false -> no UI
    |
    v
Rate dialog
    |
    +-- Cancel -> close, wait another 7 opens
    |
    v
AppReviewService.openStoreReview()
    |
    v
Android MethodChannel -> Play Store / browser fallback
    |
    v
If opened, mark prompt completed
```

Feedback screen actions:

```
FeedbackScreen
    |
    +-- write to us -> AppConfigService.supportEmail -> native email intent
    +-- privacy policy -> AppConfigService.privacyPolicyUrl -> native browser intent
    +-- rate app -> native store intent -> mark prompt completed if opened
```

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| Google Play app not installed | Falls back to web Play Store URL |
| No browser available | Returns false and shows snackbar |
| No mail app available | Returns false and shows snackbar |
| Support email is blank | Does not call native intent; shows snackbar |
| Privacy URL is blank | Does not call native intent; shows snackbar |
| User cancels rate popup | Prompt can appear after 7 more opens |
| Store action fails | Prompt is not permanently completed |
| User already opened store successfully | Prompt never appears again |

## Dependencies

- `assets/animations/review_button.gif`.
- `assets/animations/rating5.gif`.
- `assets/env.json`.
- `shared_preferences`.
- Android method channel in `MainActivity.kt`.
- `TranslationService` for all user-facing strings.

## Known Limitations

- Review flow opens the store listing, not an in-app Play Core review dialog.
- Share prompt is currently text-only; there is no native share intent yet.
- Native bridge is implemented for Android only.
- The package name used for market link is the runtime Android package name.

## Future Considerations

- Add a native share action for the share prompt.
- Add iOS implementations if the app targets iOS store release.
- Add a debug-only preference reset tool for testing prompt cadence.
- Consider a Play Core in-app review flow after package identity and release setup are finalized.
