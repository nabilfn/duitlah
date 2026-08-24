/**
 * V2 Phase 13 (Advanced Automation): user-defined and auto-learned merchant-to-category rules — the
 * single mechanism behind three of the phase's spec bullets at once: "transaction rules" (this
 * package's own CRUD surface), "automatic categorization" ({@link
 * com.duitlah.api.transactionrules.TransactionRuleService#suggestCategory} is consulted first by
 * {@code autotrack.CategorySuggestionService}, ahead of its pre-existing last-merchant lookup), and
 * "statement-learning" ({@link
 * com.duitlah.api.transactionrules.TransactionRuleService#learnFromConfirmation} upserts a rule
 * every time a user confirms an AutoTrack candidate with a category, so the per-user
 * merchant-&gt;category memory persists and improves over time instead of being recomputed fresh
 * from transaction history on every suggestion).
 *
 * <p>Module boundary: everything a rule ever does is suggest a category, never assign one
 * automatically — the same "advisory only, a human always confirms" discipline {@code
 * autotrack.TransactionCandidateService} already established. A learned rule is exactly as visible
 * and editable as a hand-authored one (see {@link
 * com.duitlah.api.transactionrules.TransactionRule#isLearned()}) — there is no hidden model behind
 * it.
 */
package com.duitlah.api.transactionrules;
