/**
 * Personal Net Worth (V2 Phase 3, spec section 19): {@code Assets - Liabilities}, always computed
 * fresh from {@code finance.Account} balances, {@link com.duitlah.api.networth.OtherAsset} (manual
 * property/vehicle entries), {@code liabilities.Liability}, and credit card outstanding balances —
 * never a stored running total. {@link com.duitlah.api.networth.NetWorthSnapshot} is the one
 * deliberate exception, written only when a user explicitly asks for a point-in-time record (spec:
 * "may be generated"), the same "freeze it at the moment of truth" choice as {@code
 * bill_final_amounts}/{@code settlements} elsewhere in this schema.
 */
package com.duitlah.api.networth;
