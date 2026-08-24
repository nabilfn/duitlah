# Bagilah Calculation Engine

Implemented in Phase 6 as `com.duitlah.api.bagilah.BagilahCalculationEngine` —
a pure, JPA/Spring-free class (inputs and outputs are plain records) so its
arithmetic can be property-tested in isolation from persistence and HTTP,
per `BagilahCalculationEngineTest`. `BillService` is the only caller; it
loads a bill's items/participants/claims, calls the engine, and turns the
result into either a live preview (`GET /bills/{id}/breakdown`) or a frozen
snapshot (`finalize()`).

## Non-negotiable invariant

For every finalized bill:

```text
SUM(participant final amounts) == bill.total
```

exactly, with no floating-point drift — verified as a property across 1,
2, and 10 participants, equal and unequal splits, shared items and shared
quantities, tax-only/service-only/tax+service, item-specific and
receipt-wide discounts, rounding discrepancies against a declared receipt
total, zero-price items, and multiple payers (`BagilahCalculationEngineTest`,
`BagilahFlowTests`). The engine never uses floating point — every amount is
`BigDecimal` — and never lets a division just round each share
independently; see `common.money.ProportionalAllocator` below.

## Claims: one type per item, not per claim

A `ReceiptItem`'s claims all share one `ClaimType` — `QUANTITY`,
`PERCENTAGE`, or `AMOUNT` — enforced by `BillService` at claim-creation time
and re-checked by the engine itself (`IssueType.MIXED_CLAIM_TYPES`) as
defense in depth. Mixing types on one item (e.g. one participant by
quantity, another by percentage) has no unambiguous reconciliation, so it's
rejected rather than guessed at. "Claim the whole item" and "equal split"
aren't separate mechanisms — they're just `QUANTITY`/`AMOUNT` claims: a
solo `QUANTITY` claim for the item's full quantity, or the
`POST .../claims/equal-split` convenience endpoint, which reuses
`common.money.EqualSplitter` to write `AMOUNT` claims that already sum to
the item's `totalPrice` exactly.

For any claim type, the engine converts each participant's claim `value`
(a quantity, a percentage, or a direct amount) into a monetary share of
that item's `totalPrice` via `common.money.ProportionalAllocator` — one
code path for all three types, since a quantity or a percentage is just a
different kind of weight. `AMOUNT` claims are already exact by
construction (validated to sum to `totalPrice` before being accepted), so
the allocator passes them through unchanged.

## Unclaimed / overallocated detection (section 14)

Before finalization, every item must be *exactly* claimed — not less
(`UNCLAIMED`), not more (`OVERALLOCATED`). This isn't a persisted bill
status; `finalize()` runs the same calculation used for the live preview
and rejects (`BILL_NOT_READY`, 400) if any item has an issue. There's no
separate "READY" state to get out of sync with reality.

## Tax, service charge, and discount allocation

- **Tax and service charge** default to proportional allocation against
  each participant's subtotal share (`AllocationStrategy.PROPORTIONAL`);
  the bill owner can switch either to `EQUAL` instead. A "custom
  per-participant override" strategy is listed as a *possible* strategy in
  the product spec but not a requirement — not built, since nothing in the
  spec's test matrix or examples needs it yet.
- **Discount** (receipt-wide, entered as a fixed RM amount — the owner
  computes a percentage discount into a fixed amount if that's how it was
  presented) is always proportional; there's no "equal discount" option
  since nothing in the spec asks for one. **Item-specific discounts**
  (`receipt_items.item_discount`) don't need a separate allocation step at
  all — they're baked into that item's `total_price`, so the engine's
  normal per-item reconciliation already accounts for them.
- Degenerate case: if every participant's subtotal is zero (e.g. no items
  claimed yet, or every claimed item happens to be free) proportional
  allocation is undefined, so tax/service/discount fall back to an equal
  split among participants instead of dividing by zero.

## Rounding: reconciling against the real receipt total

Nothing in the pure line-item math here can leave an unreconciled cent —
`EqualSplitter` and `ProportionalAllocator` both guarantee their outputs
sum back to the input exactly (largest-remainder method for the latter).
The one genuine source of drift in *manual* entry (no OCR yet) is
Malaysian retail practice: a receipt's own printed total sometimes doesn't
equal subtotal+tax+service-discount to the cent (cash rounding to the
nearest 5 sen is common). `Bill.declaredTotal` lets the owner type in what
the receipt actually says; if set, the difference from the computed total
becomes an explicit `roundingAdjustment`, allocated proportionally like
tax, and recorded on the bill rather than silently dropped — reproducing
the product spec's own worked example (computed RM111.35 vs a printed
RM111.36 must never just emit RM111.35).

## Settlement: what Phase 6 does and doesn't do

Phase 6's "Settlement" is narrow by design: `BillPayment` records who
actually paid what toward the bill (single or multiple payers, section 17),
and `GET /bills/{id}/balances` reports each participant's net position —
`paid - owed`, the same `totalPaid - totalShare` shape as Groups' balance
(see [database.md](database.md)). This is **not** a simplified "who owes
whom" transfer graph, partial-payment tracking, a mark-paid workflow, or
debt simplification across bills — those are Phase 9's job
(`settlements` module), per section 78's own phase breakdown, which lists
"who owes whom," "partial payment," "mark paid," and "debt simplification"
under Phase 9 specifically, not Phase 6.

## A deliberate exception to "computed, never stored"

Every other balance in this schema (account balance, goal progress, group
balance) is computed fresh on every read from an ever-growing ledger. A
finalized bill is different: finalizing is meant to freeze one specific
calculation as history, the same way a bank statement isn't recomputed
after the fact. `bill_final_amounts` is written once, at `finalize()`
time, and never updated afterward — see `V6__bagilah.sql` and
[database.md](database.md) for the full reasoning.

## Phase 7: collaborative claiming, guest access, real-time updates

The engine itself didn't change for Phase 7 — only who's allowed to call
into it did:

- **Claiming is participant-gated, not owner-gated.** Phase 6 put every
  claim mutation (`addClaim`/`equalSplitItem`/`removeClaim`) behind
  `requireOwnedDraftBill` (owner only). Phase 7 relaxes those three to
  `requireParticipantDraftBill`: any participant of a draft bill — the
  owner, a joined real user, or a guest — can add, adjust, or remove
  *any* claim on the bill, including someone else's ("let me fix Ameer's
  claim, he mistyped"). This is a deliberate simplification: claims
  aren't gated per claim-owner, only gated by "you're actually in this
  bill" — matching the product spec's picture of everyone looking at the
  same shared receipt together (section 13), not a fine-grained
  per-person permission model nothing in the spec asks for. Item,
  participant, and charge management, payments, and finalize/cancel
  all stay owner-only.
- **Guest access is a wholly separate mechanism from the real-user JWT.**
  A guest joins via `POST /api/v1/bagilah/join` (public) with a name, and
  gets back an opaque session token (`bill_guest_sessions`, see
  [database.md](database.md)) — not a JWT, not anything that flows
  through `JwtAuthenticationFilter` or `Authentication`. `BagilahGuestController`
  (`/api/v1/bagilah/guest/{guestToken}/...`) is a parallel, narrower
  surface to `BillController`: view the bill/items/participants/breakdown,
  and claim — nothing else. This keeps the existing owner/participant
  endpoints (and every Phase 6 test) completely untouched by guest access.
- **An authenticated user hitting the same invite link joins as
  themselves**, idempotently (like Groups' join) — `joinViaInvite`
  resolves identity from an optional Bearer JWT before falling back to
  requiring a guest name, so one link serves both "a friend with a
  Duitlah account" and "a friend with none."
- **Real-time updates are Server-Sent Events, not WebSockets or polling**
  (`BillEventBroadcaster`) — one-way push is all a claiming session
  needs, and SSE needs no extra client library. Events are content-free
  signals ("something about this bill changed"); the frontend just
  refetches on receipt rather than the server maintaining a fine-grained
  event payload contract. The broadcaster is in-memory and single-instance
  — see [architecture.md](architecture.md) for what a multi-instance
  deployment would need instead (not built, since nothing here runs on
  more than one instance).

## Phase 8: receipt scanning (`receipts` module)

The pipeline (product spec section 10) is: upload → OCR → structured
items → user verification → Bagilah. The last step is deliberately not a
separate data model — confirming a scan just calls `BillService`'s own
`create`/`addItem`/`update` (the same public methods a manual "New bill"
uses), so a confirmed scan is an ordinary Phase 6/7 bill from that point
forward, with every existing capability (collaborative claiming, invite
links, guest access, finalize) already working on it with no extra code.

- **OCR is abstracted behind `ReceiptOcrService`** (`parse(imageBytes,
  contentType) -> ParsedReceipt`), matching the spec's explicit
  requirement. `UnavailableOcrService` is the fallback when no provider
  is configured (`duitlah.receipts.ocr.anthropic-api-key` unset) — every
  field comes back null/empty, sending the user straight into manual
  entry rather than failing the upload. `ClaudeVisionOcrService` is the
  real implementation, calling Claude's vision API directly over
  `java.net.http.HttpClient` (no SDK dependency needed for one endpoint).
  Neither implementation ever throws for "couldn't read it" — that's a
  normal outcome the review UI exists for, not an error.
- **Structured output via forced tool use, not "ask for JSON and hope."**
  The Claude request sets `tool_choice` to force a call to a single
  `record_receipt` tool with a JSON-schema-defined input, so the
  response is guaranteed to match that shape — no markdown-fence
  stripping, no "the model added a sentence before the JSON" parsing
  fragility to guard against. The result is still walked defensively
  field-by-field (`ParsedReceiptCodec.fromJsonNode`) rather than trusted
  wholesale: a single missing/malformed field (an unparseable date, a
  line item missing a price) degrades that one field to null, not the
  entire scan to failure. "Never trust OCR completely" (section 10)
  applies to the shape of the response as much as its accuracy.
- **Confidence is the model's own self-reported estimate per field**
  (0.0-1.0), requested explicitly in the prompt — a heuristic, not a
  calibrated probability. It exists purely to let the review UI flag
  "double-check this" on low-confidence fields; nothing downstream
  (the calculation engine, `bill_final_amounts`) ever reads it — by the
  time a scan is confirmed, every value has already been through human
  review and become an ordinary, un-flagged bill field.
- **The user can correct everything the spec lists** (merchant, item
  names/prices/quantities, delete/add items, tax, service, discount,
  final total) because confirming a scan sends a fully independent
  payload built from whatever the review form currently holds — the
  original OCR output is never re-read or merged in at confirm time. If
  OCR misread every field, confirming with all-corrected values works
  identically to a bill with no OCR involvement at all.

## Phase 9.5: a second client, the same one engine

`apps/mobile`'s Bagilah feature (camera capture → OCR review → claim →
finalize → settlement) calls the exact same `BillController`/
`BagilahGuestController` endpoints described throughout this document —
`BagilahRepository`/`GuestBagilahRepository` in
`apps/mobile/lib/features/bagilah/data/` are thin Dio wrappers, not a
second implementation. There is still exactly one `BagilahCalculationEngine`,
one `EqualSplitter`/`ProportionalAllocator`, one `DebtSimplifier` — in
`com.duitlah.api`, nowhere else. The mobile claim sheet's "equal split"
button, for instance, calls the same `.../claims/equal-split` convenience
endpoint the web app's claim dialog does; neither client ever computes a
share client-side. See [architecture.md](architecture.md)'s Mobile section
for the rest of the mobile-specific plumbing (deep links, guest flow, SSE).

## Phase 9: what happens after `finalize()`

Finalizing a bill now does one more thing: it turns each real-user
participant's net position (`finalAmount` from `bill_final_amounts` minus
what they actually paid) into fixed `Settlement` rows via
`com.duitlah.api.settlements.DebtSimplifier`, in the same transaction as
finalization itself. This is `bagilah`'s only dependency on
`settlements` — a one-way call handing over plain net positions, nothing
about how they get turned into pairwise transfers or tracked to payment.
Guests are skipped (see [database.md](database.md)); if every
participant is a guest, finalizing produces no settlements at all, which
is correct — there's nothing for a "who owes me" dashboard to show
without a real account to show it to. See
[architecture.md](architecture.md) for how this mirrors `receipts`'
one-way dependency on `bagilah`, and [database.md](database.md) for the
settlement schema itself and why Groups needed a parallel, repeatable
"settle up" action instead of an automatic hook.
