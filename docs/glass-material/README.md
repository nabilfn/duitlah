# Glass material enhancement

The V2 page hierarchy, typography, navy financial hero and existing destinations remain in place. This pass adds shared floating materials to navigation, Ask Duitlah, selectors, hero controls, Add expense, sheets, dialogs and selected contextual controls. Charts and editorial content remain matte.

## Material system

`GlassTokens` supplies light and dark standard, strong, soft and hero materials. Standard blur is 18; floating layers use 22; hero controls use 10. Filters are cached and clipped to each surface. Controls over flat backgrounds skip unnecessary blur.

The dock overlays scrolling content with trailing clearance so the last action remains reachable. Its active lens glides between destinations and its material strengthens during scrolling. Glass buttons compress on press and change opacity and shadow. The assistant panel expands from the initiating control's bounds.

The Personal menu links to the existing Personal, Business spaces and combined net worth destinations; it does not invent a new ledger mode. Shared fields keep a semi-solid reading surface and animated focus treatment.

Reduced motion bypasses animation. High contrast uses opaque materials. On iOS, the native accessibility bridge reads Reduce Transparency at launch/resume and responds to setting changes while the app is open.

## Validation

- Complete Flutter suite: **200 tests passed**, including 10 glass-specific regression tests.
- Dart analysis: no issues.
- iOS accessibility bridge: Swift type-check passed against the installed iOS SDK.
- Light/dark previews generated with fixture data; compact 320-point layouts also checked.
- No full iOS build or physical-device GPU profiling was performed.

Pixel regression checks verify frosted coverage over contrasting backgrounds and protect against applying alpha twice through both a decoration color and its gradient. Interaction checks cover solid accessibility fallbacks, live iOS preference updates, press response, account destinations, scroll-under reachability and sheet results.

## Previews

| Screen | Light | Dark |
| --- | --- | --- |
| Home | [Preview](previews/home.png) | [Preview](previews/home_dark.png) |
| Login | [Preview](previews/login.png) | [Preview](previews/login_dark.png) |
| Bagilah | [Preview](previews/bagilah.png) | [Preview](previews/bagilah_dark.png) |
| Analytics | [Preview](previews/analytics.png) | [Preview](previews/analytics_dark.png) |
| Transactions | [Preview](previews/transactions.png) | [Preview](previews/transactions_dark.png) |
| Profile | [Preview](previews/profile.png) | [Preview](previews/profile_dark.png) |
| Add transaction | [Preview](previews/add_transaction.png) | [Preview](previews/add_transaction_dark.png) |
