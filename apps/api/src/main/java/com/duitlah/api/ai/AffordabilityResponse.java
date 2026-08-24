package com.duitlah.api.ai;

import java.math.BigDecimal;

/**
 * Every amount here is computed by {@link AffordabilityService} from real backend data (the same
 * forecast/settlement math already used elsewhere) -- {@code narrative} is a template filled in
 * with those numbers, never a value an LLM produced or altered. See AffordabilityService's class
 * comment for why the calculation and the narrative are deliberately kept separate.
 *
 * <p>V2 Phase 12 (spec section 68) widened the inputs behind {@code canAfford}: {@code
 * upcomingBillsTotal} and {@code debtRepaymentsTotal} join {@code totalOwedToOthers} as real
 * obligations against the projected balance ({@code totalObligations} is their sum -- the value
 * actually used in the {@code canAfford} check). {@code averageCreditUtilization} (a 0-1 ratio,
 * null if the user has no credit cards), {@code totalSavingsGoalsRemaining}, and {@code
 * budgetRemainingThisPeriod} are informational context surfaced alongside the verdict, not folded
 * into it -- they describe the user's broader financial posture but aren't due obligations, so
 * mixing them into the pass/fail math would make it harder to audit.
 */
public record AffordabilityResponse(
    BigDecimal amount,
    BigDecimal currentBalance,
    BigDecimal projectedBalanceIfWaited,
    BigDecimal projectedBalanceIfPurchased,
    BigDecimal totalOwedToOthers,
    BigDecimal upcomingBillsTotal,
    BigDecimal debtRepaymentsTotal,
    BigDecimal totalObligations,
    BigDecimal averageCreditUtilization,
    BigDecimal totalSavingsGoalsRemaining,
    BigDecimal budgetRemainingThisPeriod,
    boolean canAfford,
    String narrative,
    String disclaimer) {}
