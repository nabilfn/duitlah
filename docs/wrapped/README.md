# Duitlah Wrapped — editorial story

Implemented from the approved September 10 reference as individual full-screen chapters. The cream, gold and plum art direction stays consistent in Light, Dark and System. Plus Jakarta Sans remains the app font; bundled, SIL-licensed Bodoni Moda is used only for Wrapped display headlines.

## Reviewed previews

These screenshots use deterministic test fixtures, including the example August figures. Production uses authenticated monthly snapshot data.

| Chapter | Preview |
| --- | --- |
| Your story is ready | [Intro](intro.png) |
| Your month | [Overview](overview.png) |
| Month comparison | [Comparison](comparison.png) |
| Where your money went | [Categories](categories.png) |
| Persona clues | [Build-up](buildUp.png) |
| Persona reveal | [Persona](persona.png) |
| Monthly records | [Records](records.png) |
| Next month | [Savings and sharing](nextMonth.png) |

Share cards: [Money Persona](share-persona.png), [Monthly Summary](share-summary.png), [Top Category](share-category.png), [Biggest Insight](share-insight.png).

## Behaviour

- Home and Analytics offer entry points; unseen stories do not disclose the persona in advance.
- Let's go starts the story. Tap right/left or swipe to navigate. Right taps finish meaningful reveals first; persona clues lead to an explicit reveal button. The final chapter never loops.
- Income, expenses, net and goal contributions enter sequentially with count-up animation. Reduced motion shows values directly and preserves the clue interaction.
- Amounts, month comparisons, categories, persona evidence and record details can be explored in place. Optional details are shown only when present in the snapshot.
- Done marks the month viewed. Closing or navigating back midway does not. A failed completion request can be retried. Replay remains available through Analytics; reopening starts at the introduction.
- The savings recommendation is 10% of recorded monthly income, calculated with backend decimal arithmetic. With no positive income, the monetary CTA is omitted.
- The savings CTA opens the existing goal workflow with an editable target contribution, a suggested Monthly frequency, and Wrapped as its source. Create goal requires confirmation. This creates a savings target, not a recurring transfer or automatic contribution.
- Sharing previews a dedicated 9:16 card. RM amounts are opt-in. No account details, merchant notes, IDs or transaction histories are exported. Export produces a 1080 × 1920 PNG and removes temporary files after the native share operation.

## Data and compatibility

The existing aggregation, persona and recommendation services remain authoritative. New version-2 snapshots add structured category counts, comparison values, record expansions, persona statistics and the savings suggestion. Existing version-1 snapshots remain immutable and readable; missing detail reduces the chapter count instead of merging inconsistent live figures or inventing analytics. No database migration beyond the existing Wrapped migration is required for the new payload fields.

## Verification

- 165 mobile tests pass; Flutter analysis reports no issues.
- 425 backend tests pass, including HTTP/database integration and snapshot immutability. Wrapped Java formatting checks pass.
- Android debug APK and iOS simulator debug builds succeed. Existing plugin migration/arm64 simulator warnings remain unchanged.
- All chapters checked at 375, 390, 393 and 430 logical pixels, including safe areas. Additional checks cover enlarged text, long names, large amounts, sparse data, forward/back navigation, closing, completion failure, goal confirmation, sharing success/failure and reduced motion.
- Screenshots are widget renders. Native device frame-rate profiling and delivery into third-party social applications were not exercised by these automated checks.

To refresh the previews:

```sh
cd apps/mobile
flutter test --no-pub --update-goldens --dart-define=RENDER_WRAPPED=true test/features/wrapped
```
