/**
 * Products and services a business sells (V2 Phase 5, spec section 31). Deliberately minimal for
 * this phase — no stock-on-hand tracking, no cost-of-goods logic. Real inventory quantity/costing
 * is Phase 8's explicit scope ("Inventory & Costing"); a {@link com.duitlah.api.catalog.Product}
 * here is a priced catalog entry an invoice/quotation line item can reference, nothing more yet.
 */
package com.duitlah.api.catalog;
