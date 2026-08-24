-- Seed data for YA2024-YA2026, reflecting a good-faith approximation of
-- the published LHDN (Lembaga Hasil Dalam Negeri Malaysia) resident-
-- individual tax structure in effect since the Budget 2023 revision.
--
-- HONESTY NOTE (see docs/personal-tax.md): these figures come from the
-- assistant's own general knowledge, not a live LHDN feed or an official
-- dataset shipped with this repository. Malaysian tax brackets, relief
-- ceilings, and rebate rules are revised almost every Budget cycle --
-- verify every value here against the current official LHDN circular
-- before relying on any calculation this app produces for real filing.
-- This is exactly why section 26 demands YA-versioned rules in the first
-- place: a wrong or stale row here is a data-correction task (INSERT a
-- new tax_years row, or UPDATE this one with a citation), never a code
-- change, and never something that silently invalidates a prior year's
-- already-reproducible result.

DO $$
DECLARE
    ya_id UUID;
    ya INTEGER;
BEGIN
    FOREACH ya IN ARRAY ARRAY[2024, 2025, 2026]
    LOOP
        INSERT INTO tax_years (year_of_assessment, resident_individual_relief, notes)
        VALUES (ya, 9000.00,
                'Seeded approximation of the post-Budget-2023 LHDN structure -- verify against the official YA ' || ya || ' circular before relying on this for real filing.')
        RETURNING id INTO ya_id;

        INSERT INTO tax_brackets (tax_year_id, lower_bound, upper_bound, rate_percent) VALUES
            (ya_id, 0, 5000, 0),
            (ya_id, 5000, 20000, 1),
            (ya_id, 20000, 35000, 3),
            (ya_id, 35000, 50000, 6),
            (ya_id, 50000, 70000, 11),
            (ya_id, 70000, 100000, 19),
            (ya_id, 100000, 400000, 25),
            (ya_id, 400000, 600000, 26),
            (ya_id, 600000, 2000000, 28),
            (ya_id, 2000000, NULL, 30);

        INSERT INTO tax_relief_rules (tax_year_id, category, max_amount, description) VALUES
            (ya_id, 'SPOUSE', 4000.00, 'Spouse relief (no separate income, or elects joint assessment).'),
            (ya_id, 'CHILD', 8000.00, 'Per unmarried child under 18 / studying full-time (approximate; real schedule varies by child age and education level).'),
            (ya_id, 'DISABLED_INDIVIDUAL', 6000.00, 'Additional relief for a disabled individual.'),
            (ya_id, 'PARENTS_MEDICAL_CARE', 8000.00, 'Medical treatment/care expenses for parents.'),
            (ya_id, 'MEDICAL_SERIOUS_ILLNESS', 10000.00, 'Medical expenses for self/spouse/child for a serious illness.'),
            (ya_id, 'EDUCATION_FEES', 7000.00, 'Self-education fees for a course of study.'),
            (ya_id, 'LIFESTYLE', 2500.00, 'Lifestyle: books, computers, internet, and similar.'),
            (ya_id, 'LIFESTYLE_SPORTS', 500.00, 'Additional lifestyle relief for sports equipment/activities.'),
            (ya_id, 'EPF_LIFE_INSURANCE', 7000.00, 'Combined EPF contributions and life insurance premiums.'),
            (ya_id, 'PRS', 3000.00, 'Private Retirement Scheme contributions.'),
            (ya_id, 'SSPN', 8000.00, 'Net additional savings in an SSPN education savings account.'),
            (ya_id, 'EV_CHARGING', 2500.00, 'Electric vehicle charging facility expenses.'),
            (ya_id, 'OTHER', 0.00, 'Catch-all for a relief category not explicitly modeled -- no automatic cap; review manually.');

        INSERT INTO tax_rebate_rules (tax_year_id, chargeable_income_threshold, rebate_amount, description) VALUES
            (ya_id, 35000.00, 400.00, 'Individual rebate for chargeable income not exceeding RM35,000.');
    END LOOP;
END $$;
