/**
 * Business bank/cash/e-wallet/credit-card accounts (V2 Phase 5, spec section 37). Deliberately kept
 * structurally isolated from {@code finance.Account} — a business account belongs to a space, not a
 * user, and other Phase 5 modules ({@code bizexpenses}, {@code sales}) post payments against it. As
 * with {@code finance.Account}, balance is computed on read (openingBalance + signed sum of {@link
 * com.duitlah.api.bizbanking.BusinessAccountEntry} rows), never stored.
 */
package com.duitlah.api.bizbanking;
