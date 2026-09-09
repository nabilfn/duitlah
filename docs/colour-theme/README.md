# Duitlah colour theme update

Applied the supplied light and dark berry palettes through centralized `DuitlahColors` semantic tokens. Existing screen layouts, typography, spacing, navigation, and Bagilah shapes are preserved.

Profile → Appearance offers **Light**, **Dark**, and **System**. Selection applies immediately and is stored as `light`, `dark`, or `system`. The saved value loads before the Flutter UI starts; missing or inaccessible storage defaults to System. System follows device appearance changes automatically.

The seven participant fills retain the exact requested values. Their text uses contrast-selected black or white to achieve at least 4.5:1 contrast without modifying the fills.

## Previews

| Screen | Light | Dark |
| --- | --- | --- |
| Home | [Preview](home.png) | [Preview](home_dark.png) |
| Bagilah | [Preview](bagilah.png) | [Preview](bagilah_dark.png) |
| Transactions | [Preview](transactions.png) | [Preview](transactions_dark.png) |
| Analytics | [Preview](analytics.png) | [Preview](analytics_dark.png) |
| Add transaction | [Preview](add_transaction.png) | [Preview](add_transaction_dark.png) |
| Profile / Appearance | [Preview](profile.png) | [Preview](profile_dark.png) |

Previews use widget-test fixtures, not production account data.

## Verification

- All 127 Flutter tests pass, including saved appearance restoration, first-frame dark mode, live system changes, rapid selections, and storage-failure recovery.
- `flutter analyze --no-pub`: no issues.
- Android debug APK and iOS simulator debug builds succeed. The existing iOS scanner plugin reports an arm64 simulator support warning; scanner operation has not been verified on a device in this update.
- Compared against the committed pre-update UI: all 862 measured text, card, and painted-widget bounds match across 15 screen variants (normal light, enlarged-text narrow light, and dark). Profile is excluded because it contains the permitted Appearance addition.
- No backend, dependency, or financial workflow changes.
