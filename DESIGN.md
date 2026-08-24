# Design

Visual system for Duitlah. Read alongside [PRODUCT.md](PRODUCT.md) (register: product, web). This file documents *decisions and why*; the tokens themselves live in `apps/web/src/app/globals.css` and are the source of truth if the two ever disagree.

## Color

**Strategy:** Restrained structure, Committed accent. Neutrals (background, cards, borders) stay pure or near-pure; the primary brand color is not a thin accent but carries real surface area on the things that matter — primary buttons, the hero balance card, active nav state. This reconciles the product register's default (Restrained) with the confirmed brand direction (confident color-blocking): the *architecture* is restrained, the *brand color's usage* is committed.

All colors are OKLCH. Full values are in `globals.css`; roles below.

### Brand seed and why

The primary hue (350°, a deep berry-rose/magenta-crimson) was generated as a random brand-seed anchor specifically to avoid the AI-fintech color reflex (blue, purple, or teal-green defaults). It was kept — deliberately pulled toward magenta rather than true red — for a concrete reason: **true red (hue ~10–30°) is universally read as "danger/negative" in financial UIs**, and Duitlah's primary brand color needs to not collide with that meaning. Pushing the hue toward 350° (berry/magenta) keeps the color distinctive and premium without borrowing the "error" read. `--destructive` is a separate, distinctly different hue (18°, true red-orange) specifically so the brand color and the danger color are never confusable.

This also satisfies the anti-reference constraint directly: none of MAE (yellow), GXBank (purple), Touch 'n Go (blue), Wise (green/navy), Revolut (near-black/neon), or Splitwise (green) sit anywhere near a berry-magenta primary.

### Roles

| Token | Role | Light | Dark |
|---|---|---|---|
| `background` / `foreground` | Page canvas / body text | pure white / near-black ink | near-black / near-white ink |
| `card`, `popover` | Elevated surfaces | white | subtly lighter than background (layering, not a border) |
| `primary` | Primary actions, active state, hero money display | berry-rose, hue 350° | same hue, tuned lighter for dark-bg legibility |
| `secondary`, `muted`, `accent` | Structural neutrals — secondary buttons, muted text, hover states | near-pure gray with a 0.004–0.006 chroma whisper of hue 350 | dark-mode equivalents |
| `destructive` | Errors, delete, negative/danger actions | true red-orange, hue 18° | lighter red-orange for dark-bg contrast |
| `success` | Positive amounts, "paid" status | green, hue 150° | lighter green for dark-bg contrast |
| `warning` | Budget warnings, near-due reminders | amber, hue 55° | lighter amber |
| `info` | Neutral informational banners/tips | blue, hue 230° | lighter blue |
| `bagilah` | Bagilah's own identity — warm gold, hue 66–68° | always paired with **dark** text, in both themes (a light saturated gold fails contrast with white text — see the palette math run during Phase 1) | — |
| `sidebar` | Desktop nav surface | barely off-white, same brand-hue whisper | barely lighter than page background |

**Never use `--accent` (shadcn's structural hover-state token) as if it were a second brand color.** It's a neutral tint for menu/dropdown hover states. Bagilah's actual "second brand color" is the separate `--bagilah` token, reserved for that feature.

### Status is never color-only

Every status indicator (`components/finance/status-pill.tsx`) pairs its color with a distinct icon and label — required by PRODUCT.md's accessibility section and WCAG 2.1 AA in practice (color-blind users, grayscale contexts). Don't add a status representation that's color alone.

### Bg/surface pure-neutral rule

Background and card surfaces are chroma-0 or near-0 (0.004–0.006) — not a tinted "warm cream" neutral. The brand's warmth lives in `primary` and `bagilah`, not in the page background; see the AI-slop warning about cream/sand/paper defaults the skill's palette guidance flags. Don't "fix" a flat-feeling screen by tinting the background — reach for primary-carrying surface (a `BalanceCard`-style block) instead.

## Typography

**One family**, per product-register guidance (product UIs rarely need display/body pairing): Geist Sans for everything — headings, body, labels, buttons, data. It's already what `create-next-app` wired up, is genuinely well-crafted, and reads as "trusted tool" in the same register as Linear/Vercel/Stripe.

**Geist Mono is reserved exclusively for monetary figures** (`.font-amount` utility class in `globals.css`, `font-variant-numeric: tabular-nums`). This is a deliberate second use of a genuinely different family (contrast axis: humanist sans vs. monospace, not two look-alike sans), scoped narrowly so it never becomes a second "heading font." Use it for: balances, transaction amounts, split breakdowns — anywhere digits need to align in a column or read as unambiguously exact. Never for headings, labels, or prose.

Scale is a **fixed rem scale**, not fluid/clamped — product UI is viewed at consistent DPI, and headings inside a sidebar or card don't benefit from viewport-relative sizing. `h1`–`h3` get `text-wrap: balance` (in `globals.css`'s `@layer base`) so headings don't break into a visually lopsided last line.

## Components

Built on shadcn/ui (`@base-ui/react` primitives, not Radix — note the `render` prop pattern for composition, e.g. `<DialogTrigger render={<Button variant="outline" />}>Open</DialogTrigger>`, not `asChild` + nested child). Every interactive component inherits default/hover/focus/active/disabled states from the base primitives; extend, don't replace.

- **Buttons** (`components/ui/button.tsx`) — default/outline/secondary/ghost/destructive/link variants already existed from shadcn init; tokens now carry the brand. Bagilah-specific CTAs use `bg-bagilah text-bagilah-foreground` directly rather than a new button variant, since that treatment is scoped to one feature, not a general-purpose variant.
- **Cards** — plain `Card` stays a quiet, bordered/ringed neutral surface for lists and settings. `BalanceCard` (`components/finance/balance-card.tsx`) is the deliberate exception: a solid `bg-primary` surface for the one or two numbers per screen that matter most. **If every card on a screen looks like BalanceCard, that's a bug, not a feature** — it only works because it's rare.
- **Inputs** — `AmountInput` (`components/finance/amount-input.tsx`) wraps the base `Input` pattern with an `RM` prefix and `.font-amount` styling; uses `type="text" inputMode="decimal"`, never `type="number"` (which permits scientific notation and mouse-wheel value changes — both wrong for currency). Formatting/parsing is left to the caller.
- **Modals / Drawers** — shadcn `Dialog` and `Drawer` primitives, unmodified beyond token inheritance. Per product-register guidance, treat modals as a last resort — Bagilah's item-claiming and split-editing flows especially should prefer inline/progressive UI over a dialog where possible.
- **Navigation** (`components/nav/`) — `AppShell` composes `DesktopSidebar` (full item set: Home, Transactions, Budget, Bagilah, Groups, Goals, Calendar, Insights, plus Notifications/Settings/Profile/theme toggle in a footer row) and `MobileBottomNav` (Home, Transactions, Bagilah, Groups, More). Bagilah is never a plain nav item in either surface — sidebar gives it a colored pill, mobile gives it a raised circular center button — matching the master spec's "most prominent central action" requirement.
- **Toasts** — shadcn `Sonner` wrapper, already wired with semantic icons per state (success/info/warning/error/loading) before this phase; theme-aware via `next-themes`.
- **Empty states** (`components/ui/empty-state.tsx`) — icon + title + optional description + action slot. Copy should teach the interface and offer a next step, never just "nothing here" — see the Bagilah example in the design-system reference page (`/design-system`).
- **Skeletons** — shadcn `Skeleton` primitive; compose per-context (see the reference page's transaction-row example) rather than a single generic spinner. No mid-content spinners.
- **Status pills** (`components/finance/status-pill.tsx`) — see the color section above.

## Layout & motion

- Radius scale unchanged from shadcn defaults (`--radius: 0.625rem`, derived `sm`/`md`/`lg`/`xl`/`2xl` scale) — a considered, moderate radius; the anti-reference is the "everything is a white-card-shadow-rounded-xl" *pattern*, not this specific number.
- Motion budget follows product-register guidance: 150–250ms on transitions, conveying state changes only (not decorative). No orchestrated page-load sequences.
- Mobile-first: `MobileBottomNav` and `AmountInput`-style large touch targets assume one-handed use "at a restaurant table" per PRODUCT.md's user context — this is not a generic responsive afterthought.

## Dark mode

Designed as its own palette, not an inversion: background drops to near-black (not inverted white), primary/semantic colors are independently tuned (lighter L, not just "same hex, different bg") so they hold contrast against black instead of glowing or muddying. See `.dark` block in `globals.css`. Verified with a WCAG contrast calculation during this phase — every text/background and text/solid-fill pairing hits ≥4.5:1 (most exceed 6.5:1), with `bagilah` deliberately paired with dark text in both themes since light gold + white text fails contrast regardless of surrounding theme.

## Logo

`components/brand/logo.tsx` — explicitly a **Phase 1 placeholder**, not final identity. Two overlapping rounded shapes stand in for "splitting a bill between people," the one visual idea tied to Bagilah specifically rather than generic fintech iconography (coins, wallets, arrows). Replace when real brand design happens; keep the two-shape motif only if it still earns its place.

## Reference

`/design-system` (`apps/web/src/app/design-system/page.tsx`) renders every token and component on one page, wrapped in `AppShell` so navigation gets exercised too. It's a dev-only reference, not a product page — gate it behind a flag or delete it before public launch.
