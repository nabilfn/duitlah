/**
 * Duitlah AutoTrack (V2 Phase 2, spec section 10): a generalized transaction-ingestion pipeline.
 * {@code receipts} and {@code statements} each produce {@link
 * com.duitlah.api.autotrack.TransactionCandidate} rows here; this package never depends back on
 * either — the same one-directional "producer depends on recorder" shape as {@code receipts}/{@code
 * groups} depending on {@code settlements}. A candidate never becomes a real {@code transactions}
 * row on its own; {@link com.duitlah.api.autotrack.TransactionCandidateService#confirm} always
 * requires an explicit user action, even at high confidence — this pipeline suggests, it never
 * silently records money movement.
 */
package com.duitlah.api.autotrack;
