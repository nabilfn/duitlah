# Duitlah App Entry

A deep-navy environment that carries app entry, loading, login and the hand-off into Home as one continuous system. Native Flutter vector painting and a single millisecond cursor drive every stage; no additional assets or animation dependencies are required.

The rest of the product is a light, warm canvas. This navy door is deliberately the only dark surface, in both light and dark appearance settings, which is what makes it read as branded rather than as another screen.

## Palette

| Token | Value |
| --- | --- |
| `background` | `#081321` |
| `backgroundDeep` | `#06101B` |
| `blue` | `#78B5FF` |
| `blueSoft` | `#A9C8EE` |
| `text` | `#F7F9FC` |
| `textMuted` | `#90A1B6` |

Easing is `cubic-bezier(0.22, 1, 0.36, 1)` throughout — soft, front-loaded, no overshoot anywhere in the flow.

## First launch / signed out

`duitlah.` → `d.` signal → Welcome → Login. The form is fully interactive at roughly 1600 ms, inside the 1.4–1.8 s target.

| Time | Stage |
| --- | --- |
| 0–350 ms | `duitlah.` fades up with a slight rise and a letter-spacing settle |
| 350–800 ms | The wordmark recedes; the `d.` core takes focus, a thin icy ring draws around it and one highlight travels the ring exactly once |
| 800–1200 ms | The signal shrinks and rises; "Welcome to duitlah. / Your money, at ease." fades in |
| 1200–1600 ms | The welcome clears and the login form unfolds in place, staggered 36 ms per row |

A slow session resolver holds on the `d.` signal with "Getting things ready…" for as long as it needs, then continues — there is no timeout and no separate spinner screen.

| Stage | Frame |
| --- | --- |
| Quiet canvas | [0 ms](entry-0.png) |
| Wordmark | [200 ms](entry-200.png) |
| Signal forming | [400 ms](entry-400.png) |
| Signal and status | [700 ms](entry-700.png) |
| Welcome | [1000 ms](entry-1000.png) |
| Handover | [1200 ms](entry-1200.png) |
| Form unfolding | [1400 ms](entry-1400.png) |
| Interactive login | [1700 ms](entry-1700.png) |

## Returning authenticated session

The marketing sequence never replays. Once `bootstrap()` reports a live session, the flow re-bases onto a short path: the `d.` signal confirms the system is up, then the navy empties and lifts into Home at roughly 880 ms.

## Sign-in hand-off

| Step | Motion |
| --- | --- |
| Tap | The button compresses to `0.98` and enters its loading state |
| 0–220 ms | The form retracts slightly as the navy environment rises back over it |
| 0–400 ms | The `d.` signal reforms at centre with "Signing you in…", then holds for the network |
| +430–820 ms | "Welcome back, `<name>`." |
| +930–1150 ms | The navy empties, lifts 40 px and dissolves; Home scales up from `0.99` underneath |

The navy layer has to *lead* the request: authentication flipping the router straight to Home would otherwise hard-cut the login screen away mid-transition. On failure the environment lowers again over 280 ms and the error is read in place, with a thin red rule and a short fade — the form never shakes.

| Stage | Frame |
| --- | --- |
| Holding for the network | [signin-wait](signin-wait.png) |
| Greeting | [signin-welcome](signin-welcome.png) |
| Lift into Home | [signin-lift](signin-lift.png) |

## Implementation notes

`AppEntryTransition` sits in `MaterialApp.builder`, above the router. Authentication, routing, session behaviour and credentials logic are untouched: the layer owns presentation and motion only, and exposes `beginSignIn` / `completeSignIn` / `cancelSignIn` through `EntryFlow` so the login screen can drive the hand-off without the environment knowing anything about auth.

`EntryFrame.at(ms, mode)` derives every animated value for one frame from a single cursor, which is why the stages read as one system rather than as separate screens, and why a branch can re-base the cursor without a visible jump. Stage elements are stacked and aligned rather than laid out in a column, so a stage change fades and glides instead of reflowing what is still on screen.

Depth is three cheap layers — a vertical gradient, one soft radial pool and two low-opacity arcs — plus a single light sweep during loading. No particle systems, no looping animation, no continuously animated blur. The login screen paints the same backdrop in its settled state so it sits inside the same environment.

Reduced motion keeps every stage and all status information but drops parallax, ring travel, the light sweep and the pulse, and compresses the timeline to roughly 22% of its length.

## Validation

All 203 mobile tests pass and Flutter analysis is clean. Coverage includes light/dark at 320/390/430 px, the interactive-by-1600 ms target, a slow resolver holding on the signal, the returning-session short path, reduced motion, system brightness changes without restarting the timeline, background/resume with preserved input, rapid disposal and relaunch, enlarged text, section reveal ordering, and both outcomes of the sign-in hand-off.

Static frames support visual review; they are not a physical-device frame-rate benchmark.

To refresh the frames:

```sh
cd apps/mobile
flutter test --no-pub --update-goldens --dart-define=RENDER_ENTRY=true test/features/splash
```
