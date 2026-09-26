# Duitlah — editorial digital motion redesign

Implemented directly in the Flutter application from the V2 written brief. The reference image mentioned in the brief was not supplied in this session.

## Changes

- Home now follows an editorial sequence: personal introduction, financial canvas, featured expense action, scrollable commands, current budget, category spending, savings links, shared balances, and activity. The feature grid is removed.
- The canvas uses a quiet precision texture and a labelled spending-to-income trajectory. Budget progress uses one current calendar-month budget, never a sum of overlapping limits. All financial values still come from existing providers.
- Login has a navy brand composition, spacious autofill-enabled fields, password visibility, focus response, loading protection, and an animated error region. Sign-in, registration and password-reset services are unchanged.
- Launch retains the existing measured wordmark handoff and auth-readiness gate. Normal animation is approximately 1.1 seconds; reduced motion adds no animation delay.
- Bagilah uses adaptive participant positions around the user's amount to settle. Selection reveals that person's balance and related bills/groups in place. Settlement review accepts an optional person filter while preserving the existing payment flow.
- Analytics leads with the backend's monthly savings figure. Forecast and trend remain available in an expandable section. Charts have separate light/dark palettes and a finite entry reveal.
- Navigation has a smaller active area and a gliding indicator. The assistant has a stable dock outside the feature viewport, avoiding floating-action-button collisions.
- Transaction rows expand for date, description, notes and recurring status. Shared fields, buttons and segmented controls provide restrained interaction feedback.

## Validation

- **190 tests pass**, including the existing mobile suite and new interaction coverage.
- `dart analyze lib test/presentation/digital_motion_test.dart`: no issues.
- `git diff --check`: clean.
- Layout tests cover 320px and 390px widths, light/dark modes and enlarged text. Launch tests also cover 430px and 1.8× text; login is checked with a keyboard on a narrow phone.
- New checks cover balance visibility, duplicate login submission prevention, error recovery, participant-specific settlement routing, transaction expansion and reduced motion.
- Previews below are rendered Flutter widgets with test fixtures, not live account data. These are widget-level checks; device frame-time profiling and live backend testing were not performed.

## Previews

| Screen | Light | Dark |
| --- | --- | --- |
| Home | [Preview](previews/home.png) | [Preview](previews/home_dark.png) |
| Login | [Preview](previews/login.png) | [Preview](previews/login_dark.png) |
| Bagilah | [Preview](previews/bagilah.png) | [Preview](previews/bagilah_dark.png) |
| Analytics | [Preview](previews/analytics.png) | [Preview](previews/analytics_dark.png) |
| Transactions | [Preview](previews/transactions.png) | [Preview](previews/transactions_dark.png) |

Regenerate previews from `apps/mobile`:

```sh
flutter test --no-pub --update-goldens \
  --dart-define=RENDER_UI=true \
  --dart-define=UI_PREVIEW_DIR=../../../../docs/redesign-v2/previews \
  test/presentation/reference_redesign_test.dart
```

On this machine, native hooks needed `xcrun` to resolve the installed Command Line Tools SDK rather than the unconfigured Xcode installation. Validation used a temporary `xcrun` wrapper exporting `DEVELOPER_DIR=/Library/Developer/CommandLineTools`; no system configuration or Xcode license was changed.
