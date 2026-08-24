-- Seed data for sst_rates and einvoice_mandate_rules.
--
-- HONESTY NOTE (see docs/business-tax.md): these figures were pulled from
-- a live web search performed at implementation time (August 2026) against
-- public secondary sources (tax advisory blogs, e-Invoicing compliance
-- vendors, and a Sovos regulatory-change alert) describing LHDN/RMCD
-- announcements -- not fetched directly from the LHDN/RMCD gazette or the
-- official MyInvois SDK's own reference-data endpoint. Malaysian SST rates
-- and the e-Invoice mandate rollout are both under active revision (the
-- e-Invoice exemption threshold itself changed from RM500,000 to
-- RM1,000,000 between when this phase was scoped and when it was
-- implemented -- exactly the "do not hardcode one permanent threshold"
-- risk spec section 57 warns about). Verify every row here against the
-- official LHDN MyInvois SDK (sdk.myinvois.hasil.gov.my) and the Royal
-- Malaysian Customs Department's SST portal before relying on this for a
-- real filing or compliance decision. A wrong or stale row is a data
-- correction (INSERT a new row, never edit history), never a code change.

-- SST: only the two headline/standard rates are seeded. Malaysia's Service
-- Tax also has documented reduced rates (6%) for specific categories
-- (food & beverage, telecommunications, logistics, parking, construction,
-- healthcare, education) and Sales Tax has a reduced 5% band for certain
-- goods -- this phase deliberately does not attempt a full taxable-service/
-- goods category classifier (the same "label, not a computed rate lookup"
-- scope boundary catalog.TaxClassification drew for itself in Phase 8);
-- SstRateService always returns the standard rate for its tax type, and a
-- business subject to a reduced-rate category must confirm and apply it
-- manually.
INSERT INTO sst_rates (tax_type, rate_percent, effective_from, description) VALUES
    ('SALES', 10.00, '2018-09-01', 'Standard Sales Tax rate. A reduced 5% band applies to certain goods categories -- confirm applicability manually.'),
    ('SERVICE', 8.00, '2024-03-01', 'Standard Service Tax rate. A reduced 6% band applies to food & beverage, telecommunications, logistics, parking, construction, healthcare, and education -- confirm applicability manually.');

-- e-Invoice mandate rollout: each row's revenue_threshold is the minimum
-- annual revenue, as of that effective_date, above which e-Invoicing
-- becomes mandatory (i.e. the exemption boundary at that point in the
-- phased rollout).
INSERT INTO einvoice_mandate_rules (effective_date, revenue_threshold, description) VALUES
    ('2024-08-01', 100000000.00, 'Phase 1: businesses with annual revenue above RM100 million.'),
    ('2025-01-01', 25000000.00, 'Phase 2: annual revenue above RM25 million.'),
    ('2025-07-01', 5000000.00, 'Phase 3: annual revenue above RM5 million.'),
    ('2026-01-01', 1000000.00, 'Phase 4 (soft launch; full enforcement with penalties from 2027-01-01): annual revenue above RM1 million -- also reflects the Cabinet-approved exemption threshold increase from RM500,000, effective this date.');
