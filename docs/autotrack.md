# Duitlah AutoTrack, Statement Import, and the Receipt Vault

Implemented in **V2 Phase 2** (Personal Gap Closure I — spec sections 10-15),
continuing from [financial-spaces.md](financial-spaces.md)'s V2 Phase 1
foundation.

## The pipeline

Spec section 10's own diagram is implemented literally:

```text
Input Source (receipt OCR, bank statement)
    │
    ▼
Transaction Candidate
    │
    ├── Parse            — each producer's own parser
    ├── Normalize         — into (amount, currency, merchant, date, direction)
    ├── Detect duplicates — DuplicateDetectionService
    ├── Identify account  — most-recently-used account, or the account the
    │                       statement was uploaded against
    ├── Detect merchant   — carried through from the parse step
    ├── Suggest category  — CategorySuggestionService
    └── Assign confidence — the producer's own per-row/per-scan confidence
            │
            ▼
       User confirmation  — TransactionCandidateService.confirm/reject/merge
            │
            ▼
      Existing transaction ledger — via TransactionService.create, unchanged
```

`com.duitlah.api.autotrack` owns `TransactionCandidate` and never depends on
its producers (`receipts`, `statements`) — the same one-directional
"producer depends on recorder" shape `settlements` already established for
`bagilah`/`groups`. **A candidate never becomes a real `transactions` row on
its own.** `TransactionCandidateService.confirm` is the only path in, and it
always requires an explicit request from the client — even a candidate with
0.95 confidence sits in `PENDING` until a human acts on it. This is a
deliberate reading of the spec's own "User confirmation" box in the diagram
above: a suggestion pipeline, not an auto-posting one.

## Statuses (spec section 11, unmodified)

`PENDING → CONFIRMED` / `PENDING → REJECTED` / `PENDING → DUPLICATE`
(only reachable via an explicit "Merge" action once a possible duplicate has
been flagged) / `FAILED` (a row a producer couldn't parse into anything
usable — created directly in this state, never silently dropped). There is
no sixth status invented beyond what the spec names.

`CandidateSourceType` only lists what this phase actually produces
(`RECEIPT_OCR`, `STATEMENT_CSV`, `STATEMENT_XLSX`, `STATEMENT_PDF`) — the
spec's diagram also names notification capture, shared text, and wallet
capture as future sources, but those need mobile-native OS integration (a
notification listener, a share-sheet intent handler) that's a later phase's
work, not an enum value with no code path behind it.

## Duplicate detection (spec section 12)

`DuplicateDetectionService` never discards a candidate for looking like a
duplicate — it only attaches a confidence-scored guess (`duplicateOfTransactionId`
+ `duplicateConfidence`) to a candidate that otherwise stays `PENDING`. A
human always resolves it via one of the spec's own three actions: **Keep
Both** (just `confirm` as normal — a duplicate flag doesn't block
confirming), **Merge** (moves the candidate straight to `DUPLICATE`, no new
transaction created — "this is already that transaction"), or **Ignore**
(`reject`).

Scoring (`DuplicateDetectionService.score`, unit-tested in isolation,
Spring-free): amount is a hard filter (exact match within a 3-day window,
not a scored signal — a different amount is unlikely enough to be the same
real transaction that a fuzzy match here would create more false positives
than it prevents), then merchant (+0.5 exact / +0.3 substring),
date proximity (+0.3 same day / +0.2 one day / +0.1 further within the
window), and account match (+0.2). Below a 0.5 threshold, nothing is
flagged — not every coincidental amount match deserves a banner.

## Bank statement import (spec section 13)

`com.duitlah.api.statements` implements the adapter architecture the spec
asks for: `StatementParser` is the interface, and every parsed row becomes
one `TransactionCandidate` in the same upload request — there's no separate
"review the raw parsed rows" screen, since AutoTrack's own PENDING list
already is that review step.

**Only `GENERIC_CSV`, `GENERIC_EXCEL`, and `PDF` are implemented.**
Provider-specific parsers (Maybank/CIMB/RHB, named in the spec) are
deliberately not built — this repository has no verified real export-format
samples for any of them, and a parser that silently misreads genuine bank
data because it guessed at a format is worse than not offering one at all,
the same "don't fabricate a working integration" posture as
`subscriptions.SubscriptionVerifier`/`settlements.PaymentHandoffService`.
`StatementParser` is the real extension point once real samples exist.

- **`GenericCsvStatementParser`** / **`GenericExcelStatementParser`** share
  a column-detection heuristic (`StatementParsingSupport`): look for a date
  header, a description header, and either one signed amount column or a
  debit/credit pair — a shape most bank/e-wallet exports share even though
  exact header names vary.
- **`PdfStatementParser`** is genuinely best-effort — a PDF has no real
  column structure once text is extracted, so it scans each line for a
  leading date and a trailing amount and treats what's between them as the
  description, at a deliberately lower confidence (0.6 vs. 0.7-0.9 for the
  structured formats). Every row still goes through AutoTrack's own
  human-confirmation step regardless.
- An unparseable row is skipped, not fatal to the whole file (spec: "when
  unsupported, provide a review experience instead of failing completely").
  A file with zero parseable rows marks the `StatementImport` `FAILED` with
  a plain-language reason rather than a stack trace.

## Receipt Vault (spec section 14-15)

`com.duitlah.api.receipts` gained a second entity, `Receipt`, alongside the
existing Bagilah-only `ReceiptScan` — deliberately not a rewrite of it.
`ReceiptScanService`/`POST /api/v1/receipts/scans` (Bagilah's own
scan-and-confirm flow) is completely untouched by this phase; both reuse
the same `ReceiptOcrService` interface (spec section 14: "do not duplicate
the OCR engine"), but a Vault upload never creates a Bagilah bill and a
Bagilah scan never creates a Vault row.

A Vault receipt is tagged with a `purpose` (`PERSONAL_EXPENSE`,
`BUSINESS_EXPENSE`, `TAX_EVIDENCE`, `BAGILAH` — tagging only, no bill
creation — or `UNSPECIFIED`), can carry a `folder` and free-form `tags`
(searchable, alongside merchant/date), and can attach to an existing
transaction afterward (`linkedTransactionId`) — it's never required to
attach at upload time, since a receipt often gets scanned before its
matching transaction exists yet. Uploading with purpose `PERSONAL_EXPENSE`
or `BUSINESS_EXPENSE` — when OCR actually read a total — automatically
creates a `TransactionCandidate` (`RECEIPT_OCR` source), the same "receipt
OCR" AutoTrack source the pipeline diagram names; a `TAX_EVIDENCE` or
`BAGILAH`-tagged upload does not, since those aren't standing in for an
untracked personal/business expense.

"Batch scanning" (spec section 15) is `POST /api/v1/receipts/vault`
accepting a list of files in one request — each becomes its own `Receipt`
row via the same upload logic, not a separate batch-specific code path.

## Endpoints

| Method | Path | Notes |
|---|---|---|
| `GET` | `/api/v1/autotrack/candidates?status=` | Defaults to every status if omitted. |
| `GET` | `/api/v1/autotrack/candidates/{id}` | 404 if not the owner. |
| `POST` | `/api/v1/autotrack/candidates/{id}/confirm` | Body is a `CreateTransactionRequest` — the same shape a manual "Add transaction" sends. |
| `POST` | `/api/v1/autotrack/candidates/{id}/reject` | "Ignore." |
| `POST` | `/api/v1/autotrack/candidates/{id}/merge` | "This is already that transaction" — 400 if not flagged as a possible duplicate. |
| `POST` | `/api/v1/statement-imports?accountId=` | Multipart `file`; detects CSV/XLSX/PDF from filename/content-type. |
| `GET` | `/api/v1/statement-imports` / `/{id}` | |
| `POST` | `/api/v1/receipts/vault?purpose=&folder=&tags=` | Multipart `files` (one or more). |
| `GET` | `/api/v1/receipts/vault?folder=&merchant=` / `/{id}` | |
| `POST` | `/api/v1/receipts/vault/{id}/attach?transactionId=` | |

## Mobile

Three screens, reachable from the More menu: **Review transactions**
(`AutoTrackCandidatesScreen` — confirm/reject/merge, with a possible-
duplicate banner), **Import statement** (`StatementImportScreen` — account
picker + `file_picker` for CSV/XLSX/PDF, routes straight into the review
screen on success), and **Receipt Vault** (`ReceiptVaultScreen` — batch
upload via `image_picker`'s multi-image picker, folder search, a detail
screen to attach a receipt to an existing transaction). `apps/web` is
untouched, per the Phase 9.5 mobile-first pattern for new features.

## Tests

Backend: `DuplicateDetectionServiceTest` (3 pure unit tests on the scoring
function), `AutoTrackFlowTests` (6 integration tests — statement upload
producing candidates, confirm/reject/merge, duplicate flagging end-to-end,
unsupported file type, cross-user 404), `ReceiptVaultFlowTests` (5
integration tests — upload/search/attach, unsupported type, cross-user
404). Mobile: `transaction_candidate_json_test.dart` (2 tests),
`vault_receipt_json_test.dart` (1 test).

OCR-success behavior (a Vault upload with a real parsed total
auto-creating a candidate) can't be exercised in these tests without a real
`ANTHROPIC_API_KEY` — the same constraint `ReceiptScanFlowTests` already
documented for Bagilah's own scan tests. The actual wiring is exercised
directly in `AutoTrackFlowTests` via `TransactionCandidateService.create`,
the exact shared method a successful OCR parse would call into.
