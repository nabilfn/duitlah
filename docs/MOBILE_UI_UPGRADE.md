# Duitlah reference-based mobile redesign

The September 8 forest-green reference supersedes the earlier teal/orange UI pass. Implementation stays in Flutter with Plus Jakarta Sans and the existing Riverpod, GoRouter, repository, authentication and server-side financial architecture.

## Review the result

These are renders of the actual Flutter screens using isolated test fixtures, not live user data. The production app still reads its APIs.

| Screen | Light | Dark |
|---|---|---|
| Home | [Preview](mobile-redesign/home.png) | [Preview](mobile-redesign/home_dark.png) |
| Bagilah | [Preview](mobile-redesign/bagilah.png) | [Preview](mobile-redesign/bagilah_dark.png) |
| Transactions | [Preview](mobile-redesign/transactions.png) | [Preview](mobile-redesign/transactions_dark.png) |
| Analytics | [Preview](mobile-redesign/analytics.png) | [Preview](mobile-redesign/analytics_dark.png) |
| Add transaction | [Preview](mobile-redesign/add_transaction.png) | [Preview](mobile-redesign/add_transaction_dark.png) |
| Profile | [Preview](mobile-redesign/profile.png) | [Preview](mobile-redesign/profile_dark.png) |

## Design and workflows

- Integrated forest home header, balance visibility, four reachable quick actions, compact savings/budget/spending modules and Bagilah feature surface. No fabricated rewards, payment product or investment offer.
- Organic, asymmetric Bagilah composition uses real bills and participant initials. New split, receipt scan, QR joining, groups, settlements and bill history remain reachable. The full history uses a virtualized list.
- Understated Home / Transactions / Analytics / Bagilah / Profile navigation. Each tab retains its own route stack; all existing route paths are retained. Groups and the complete toolkit remain available from Bagilah/Profile.
- Transaction search within the current page, backend account/type filters, page navigation and date-grouped rows. Currency labels follow the account. The backend does not expose a text-search parameter, so the search scope is stated in the UI.
- Expense/income/transfer entry uses the existing write endpoints. Amount validation, category/account selection, date, merchant and notes are supported where accepted by those endpoints. Submitting disables controls, preserves an idempotency key on an unchanged retry and refreshes affected views. Unsupported receipt/tag linking is not simulated.
- Analytics retains cash-flow forecast, trend and merchants while adding the reference's category donut, category selection, income view and net-worth view. Category percentages/totals are display calculations only; ledger calculations remain server-side.
- Profile uses grouped rows and muted initials. Business opens the existing workspace selection, and Both opens combined net worth; company and personal ledgers are not merged. Existing biometric, logout and account deletion flows are retained. The pre-existing inactive Active sessions control is explicitly unavailable rather than a dead tap target.
- Categories exposes the same category data used by transaction entry. The toolkit now includes all 25 previous entries plus Groups and Categories.
- Business dashboard has its own cash-position/receivables/payables hierarchy, quick actions and grouped operational tools. Goals, budgets, account presentation, bill detail/create, tax/report hubs and authentication use the same family of surfaces and controls.
- Shared forest/sage/ivory light and green dark themes, custom vector icon drawings across 88 presentation files, rounded segmented controls, consistent dropdown carets, currency formatting, state widgets and mobile form treatment extend through the secondary personal/business screens. Twenty-five simple sheet forms gained scrolling; complex editors retain their existing scroll/flex ownership.

## Validation

- Flutter static analysis: clean.
- Full test suite: 119 passing tests.
- Primary navigation and expense/transfer repository interaction tests.
- Six reference screens rendered in light/dark mode and at 320px with enlarged text; the small transaction form also includes keyboard insets.
- Existing money, authentication UI and domain/JSON regression tests retained.
- Route-path comparison: no existing paths removed; Categories added.
- Android debug APK and iOS simulator app built successfully.
- Rendered previews inspected and corrected for icon sizing, dark search contrast, amount visibility and selected-pill shapes.

## Native outputs and verification limits

- Android: `apps/mobile/build/app/outputs/flutter-apk/app-debug.apk`
- iOS simulator: `apps/mobile/build/ios/iphonesimulator/Runner.app`
- Build URLs retain existing defaults: Android emulator `http://10.0.2.2:8080`; iOS simulator `http://localhost:8080`. Use `--dart-define=API_BASE_URL=...` for another backend.

Live-backend end-to-end operation, physical-device biometrics/camera/QR and every secondary screen's populated state have not been exhaustively verified. Builds report existing plugin migration warnings (Kotlin Gradle plugin use, and iOS scanner dependencies' arm64 simulator/Swift Package Manager support). No dependency migration or release deployment was performed.

The user's pre-existing iOS `Info.plist` change and owner launch checklist PDF were preserved.
