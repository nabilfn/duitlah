/**
 * Bank statement import (V2 Phase 2, spec section 13): upload a CSV/XLSX/PDF export, parse it into
 * normalized rows via a {@link com.duitlah.api.statements.StatementParser} adapter, and hand each
 * row to {@code autotrack} as a {@link com.duitlah.api.autotrack.TransactionCandidate} — this
 * package never writes to {@code transactions} directly, the same "producer depends on recorder"
 * shape {@code receipts} already has with {@code bagilah}/{@code autotrack}.
 *
 * <p>Provider-specific parsers (Maybank/CIMB/RHB, named in the spec) are deliberately not
 * implemented here — this repository has no verified real export-format samples for any of them,
 * and a parser that silently misreads genuine bank data because it guessed at a format is worse
 * than not offering one at all (the same "don't fabricate a working integration" posture as {@code
 * subscriptions.SubscriptionVerifier}/{@code settlements.PaymentHandoffService}). {@link
 * StatementParser} is the real extension point once real samples exist; {@link
 * GenericCsvStatementParser}/{@link GenericExcelStatementParser}/{@link PdfStatementParser} are
 * genuinely implemented today, matching the spec's own "when unsupported, provide a review
 * experience instead of failing completely" instruction for anything outside those three shapes.
 */
package com.duitlah.api.statements;
