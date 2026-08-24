/**
 * Loans, BNPL, and credit card liabilities (V2 Phase 3, spec sections 17-18). {@link
 * com.duitlah.api.liabilities.Liability} covers everything that isn't a credit card (personal/car/
 * housing/education loans, PTPTN, BNPL, other); a credit card stays a {@code finance.Account} with
 * {@code type = CREDIT_CARD} exactly as before, extended by a one-to-one {@link
 * com.duitlah.api.liabilities.CreditCardDetails} row — not a second, parallel liability, because a
 * card's purchases already need to be ordinary transactions (spec: "credit-card purchases should
 * affect spending when purchased"), which only works if the card is still the same {@code Account}
 * every other transaction-writing code path already understands.
 *
 * <p>A credit card's repayment reuses the existing transfer mechanism — {@code
 * TransactionService#createTransfer} — untouched: paying a card is a transfer from a cash account
 * into the card account, an {@code IN} transaction that reduces the card's own negative balance
 * back toward zero. This is the literal implementation of spec section 18's "repayments should move
 * liability/cash rather than become a second expense," with zero new transaction-writing code.
 */
package com.duitlah.api.liabilities;
