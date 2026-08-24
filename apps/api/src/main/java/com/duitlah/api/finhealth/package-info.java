/**
 * The Financial Health Score (V2 Phase 3, spec section 20). Deterministic and explainable by
 * construction: every component is a plain arithmetic formula over data this app already computes
 * elsewhere ({@code analytics}, {@code finance}, {@code budgets}, {@code bills}, {@code
 * liabilities}, {@code networth}) — there is no model call, no learned weight, nothing an LLM
 * touches. This is the same "don't let the AI become the source of truth for financial
 * calculations" discipline as {@code ai.AffordabilityService}, applied to a new feature rather than
 * retrofitted onto an existing one.
 */
package com.duitlah.api.finhealth;
