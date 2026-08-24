/**
 * Business contacts (V2 Phase 5, spec sections 39-40): {@link com.duitlah.api.crm.Customer} and
 * {@link com.duitlah.api.crm.Supplier} are deliberately near-identical siblings, not one
 * polymorphic "contact" table with a type discriminator — a customer and a supplier are referenced
 * from structurally different places ({@code sales} vs {@code bizexpenses}) and will diverge
 * further once Phase 10's SST/MyInvois work needs customer-specific e-invoicing fields, so
 * collapsing them now would just need un-collapsing later.
 */
package com.duitlah.api.crm;
