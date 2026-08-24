-- Accounts, categories, and transactions for Phase 3 (Personal Finance MVP).
--
-- Enum-like columns use VARCHAR + CHECK rather than a native Postgres enum
-- type: changing a CHECK constraint is a simple migration, changing a
-- native enum's values requires ALTER TYPE and is far more disruptive as
-- the domain grows across later phases.

CREATE TABLE accounts (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name              VARCHAR(120) NOT NULL,
    type              VARCHAR(20) NOT NULL CHECK (type IN ('CASH', 'BANK', 'E_WALLET', 'CREDIT_CARD', 'SAVINGS', 'INVESTMENT', 'OTHER')),
    currency          VARCHAR(3) NOT NULL DEFAULT 'MYR',
    opening_balance   NUMERIC(14, 2) NOT NULL DEFAULT 0,
    archived_at       TIMESTAMPTZ,
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_accounts_user_id ON accounts(user_id);

-- user_id NULL = system default category, available to everyone and not
-- editable/deletable by users. Non-null = a user's own custom category.
-- parent_id models a (deliberately shallow, two-level) category tree.
CREATE TABLE categories (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID REFERENCES users(id) ON DELETE CASCADE,
    parent_id   UUID REFERENCES categories(id) ON DELETE CASCADE,
    type        VARCHAR(10) NOT NULL CHECK (type IN ('INCOME', 'EXPENSE')),
    name        VARCHAR(80) NOT NULL,
    icon        VARCHAR(16),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_categories_user_id ON categories(user_id);
CREATE INDEX idx_categories_parent_id ON categories(parent_id);

-- Every transaction row affects exactly one account. A transfer is two
-- linked rows (one OUT of the source account, one IN to the destination
-- account) sharing transfer_group_id — this keeps "an account's balance
-- is SUM of its own transaction rows" true without special-casing
-- transfers, and each account's history shows its own side of the
-- transfer naturally.
CREATE TABLE transactions (
    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id            UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    account_id         UUID NOT NULL REFERENCES accounts(id) ON DELETE CASCADE,
    type               VARCHAR(10) NOT NULL CHECK (type IN ('INCOME', 'EXPENSE', 'TRANSFER')),
    direction          VARCHAR(3) NOT NULL CHECK (direction IN ('IN', 'OUT')),
    category_id        UUID REFERENCES categories(id) ON DELETE SET NULL,
    transfer_group_id  UUID,
    amount             NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    merchant           VARCHAR(120),
    description        VARCHAR(255),
    notes              TEXT,
    occurred_on        DATE NOT NULL,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_transactions_user_id_occurred_on ON transactions(user_id, occurred_on DESC);
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_transfer_group_id ON transactions(transfer_group_id);

-- Default categories. Expense side matches the master spec's category
-- list exactly (section 23); the income side has no equivalent in the
-- spec, so a small reasonable default set is added here as a documented
-- assumption (see docs/database.md) rather than left empty.

WITH parent AS (
    INSERT INTO categories (user_id, parent_id, type, name, icon) VALUES (NULL, NULL, 'EXPENSE', 'Food', '🍔') RETURNING id
)
INSERT INTO categories (user_id, parent_id, type, name, icon)
SELECT NULL, parent.id, 'EXPENSE', v.name, v.icon FROM parent,
    (VALUES ('Restaurants', '🍽️'), ('Cafe', '☕'), ('Groceries', '🛒'), ('Delivery', '🛵'), ('Snacks', '🍿')) AS v(name, icon);

WITH parent AS (
    INSERT INTO categories (user_id, parent_id, type, name, icon) VALUES (NULL, NULL, 'EXPENSE', 'Transport', '🚗') RETURNING id
)
INSERT INTO categories (user_id, parent_id, type, name, icon)
SELECT NULL, parent.id, 'EXPENSE', v.name, v.icon FROM parent,
    (VALUES ('Fuel', '⛽'), ('Grab', '🚕'), ('Public Transport', '🚆'), ('Parking', '🅿️'), ('Toll', '🛣️'), ('Vehicle Maintenance', '🔧')) AS v(name, icon);

WITH parent AS (
    INSERT INTO categories (user_id, parent_id, type, name, icon) VALUES (NULL, NULL, 'EXPENSE', 'Shopping', '🛍️') RETURNING id
)
INSERT INTO categories (user_id, parent_id, type, name, icon)
SELECT NULL, parent.id, 'EXPENSE', v.name, v.icon FROM parent,
    (VALUES ('Clothing', '👕'), ('Electronics', '💻'), ('Personal', '🧴'), ('Online Shopping', '📦')) AS v(name, icon);

WITH parent AS (
    INSERT INTO categories (user_id, parent_id, type, name, icon) VALUES (NULL, NULL, 'EXPENSE', 'Lifestyle', '🎉') RETURNING id
)
INSERT INTO categories (user_id, parent_id, type, name, icon)
SELECT NULL, parent.id, 'EXPENSE', v.name, v.icon FROM parent,
    (VALUES ('Entertainment', '🎬'), ('Gaming', '🎮'), ('Sports', '⚽'), ('Travel', '✈️')) AS v(name, icon);

WITH parent AS (
    INSERT INTO categories (user_id, parent_id, type, name, icon) VALUES (NULL, NULL, 'EXPENSE', 'Bills', '🧾') RETURNING id
)
INSERT INTO categories (user_id, parent_id, type, name, icon)
SELECT NULL, parent.id, 'EXPENSE', v.name, v.icon FROM parent,
    (VALUES ('Rent', '🏠'), ('Electricity', '💡'), ('Water', '🚰'), ('Internet', '📶'), ('Phone', '📱'), ('Insurance', '🛡️')) AS v(name, icon);

WITH parent AS (
    INSERT INTO categories (user_id, parent_id, type, name, icon) VALUES (NULL, NULL, 'EXPENSE', 'Education', '📚') RETURNING id
)
INSERT INTO categories (user_id, parent_id, type, name, icon)
SELECT NULL, parent.id, 'EXPENSE', v.name, v.icon FROM parent,
    (VALUES ('Tuition', '🎓'), ('Books', '📖'), ('Software', '🖥️')) AS v(name, icon);

WITH parent AS (
    INSERT INTO categories (user_id, parent_id, type, name, icon) VALUES (NULL, NULL, 'EXPENSE', 'Financial', '💳') RETURNING id
)
INSERT INTO categories (user_id, parent_id, type, name, icon)
SELECT NULL, parent.id, 'EXPENSE', v.name, v.icon FROM parent,
    (VALUES ('Savings', '🏦'), ('Investments', '📈'), ('Loan', '💸'), ('Credit Card', '💳')) AS v(name, icon);

WITH parent AS (
    INSERT INTO categories (user_id, parent_id, type, name, icon) VALUES (NULL, NULL, 'INCOME', 'Income', '💰') RETURNING id
)
INSERT INTO categories (user_id, parent_id, type, name, icon)
SELECT NULL, parent.id, 'INCOME', v.name, v.icon FROM parent,
    (VALUES ('Salary', '🧑‍💼'), ('Freelance', '🧑‍💻'), ('Business', '🏪'), ('Gifts', '🎁'), ('Investment Returns', '📈'), ('Other Income', '➕')) AS v(name, icon);
