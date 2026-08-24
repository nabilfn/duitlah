package com.duitlah.api.accounting;

import java.util.List;

/**
 * A Malaysian SME-friendly starting Chart of Accounts (spec section 35). These codes/names are a
 * reasonable general-purpose default, not a statutory or LHDN-mandated numbering — unlike the
 * Personal Tax Centre's tax brackets, a chart of accounts is a business convention a space's own
 * accountant is always free to rename, reorder, or extend after seeding (spec: "allow controlled
 * customization").
 *
 * <p>The codes marked as system defaults for automatic posting ({@link #ACCOUNTS_RECEIVABLE_CODE},
 * {@link #ACCOUNTS_PAYABLE_CODE}, {@link #SALES_REVENUE_CODE}, {@link #TAX_PAYABLE_CODE}, {@link
 * #DEFAULT_EXPENSE_CODE}, {@link #INVENTORY_CODE}, {@link #COGS_CODE}, {@link #FIXED_ASSETS_CODE},
 * {@link #ACCUMULATED_DEPRECIATION_CODE}, {@link #DEPRECIATION_EXPENSE_CODE}, {@link
 * #GAIN_LOSS_ON_DISPOSAL_CODE}, {@link #OWNER_CAPITAL_CODE}, {@link #OWNER_DRAWINGS_CODE}, {@link
 * #DUE_TO_OWNER_CODE}) are the ones {@link AutomaticPostingService} looks up by code — if a space
 * renames or archives one of these, automatic posting for that space simply stops finding it and
 * skips (see the module's own package-info). {@link #INVENTORY_CODE}/{@link #COGS_CODE} are V2
 * Phase 8's own addition (inventory.AutomaticStockPostingService) — both accounts were already
 * seeded here in Phase 6, unused until that phase gave them a real purpose. {@link
 * #FIXED_ASSETS_CODE} is the same story for V2 Phase 9 (assets); {@link
 * #ACCUMULATED_DEPRECIATION_CODE}, {@link #DEPRECIATION_EXPENSE_CODE}, and {@link
 * #GAIN_LOSS_ON_DISPOSAL_CODE} are new seeds Phase 9 adds. Accumulated Depreciation is a
 * contra-asset seeded as a plain {@link AccountType#ASSET} — since it is only ever credited, {@link
 * NormalBalance#signedAmount} naturally reports it as a negative balance, which is exactly the
 * contra-asset behavior a Balance Sheet needs, with no new account type required. Gain/Loss on
 * Disposal is likewise seeded as a plain {@link AccountType#REVENUE}: a gain credits it positive, a
 * loss debits it negative — the same "can go negative" convention {@code BalanceSheetService}
 * already uses for its own "Current Earnings" line. {@link #OWNER_CAPITAL_CODE}/{@link
 * #OWNER_DRAWINGS_CODE} are V2 Phase 6's own seeds, unused by automatic posting until V2 Phase 11
 * (crossspace) gives them a real purpose; {@link #DUE_TO_OWNER_CODE} is Phase 11's one new seed — a
 * single {@link AccountType#LIABILITY} account that covers "due to/from owner" in both directions
 * (spec section 58), the same signed-balance trick used everywhere else in this class rather than a
 * separate asset-side "Due from Owner" account.
 */
final class DefaultChartOfAccounts {

  static final String ACCOUNTS_RECEIVABLE_CODE = "1020";
  static final String ACCOUNTS_PAYABLE_CODE = "2000";
  static final String SALES_REVENUE_CODE = "4000";
  static final String TAX_PAYABLE_CODE = "2020";
  static final String DEFAULT_EXPENSE_CODE = "6900";
  static final String INVENTORY_CODE = "1030";
  static final String COGS_CODE = "5000";
  static final String FIXED_ASSETS_CODE = "1500";
  static final String ACCUMULATED_DEPRECIATION_CODE = "1510";
  static final String DEPRECIATION_EXPENSE_CODE = "6100";
  static final String GAIN_LOSS_ON_DISPOSAL_CODE = "4910";
  static final String OWNER_CAPITAL_CODE = "3000";
  static final String OWNER_DRAWINGS_CODE = "3020";
  static final String DUE_TO_OWNER_CODE = "2030";

  record Seed(String code, String name, AccountType type, boolean cashEquivalent) {
    Seed(String code, String name, AccountType type) {
      this(code, name, type, false);
    }
  }

  static final List<Seed> ACCOUNTS =
      List.of(
          new Seed("1000", "Cash on Hand", AccountType.ASSET, true),
          new Seed("1010", "Bank Account", AccountType.ASSET, true),
          new Seed(ACCOUNTS_RECEIVABLE_CODE, "Accounts Receivable", AccountType.ASSET),
          new Seed("1030", "Inventory", AccountType.ASSET),
          new Seed("1040", "Prepaid Expenses", AccountType.ASSET),
          new Seed(FIXED_ASSETS_CODE, "Fixed Assets", AccountType.ASSET),
          new Seed(ACCUMULATED_DEPRECIATION_CODE, "Accumulated Depreciation", AccountType.ASSET),
          new Seed(ACCOUNTS_PAYABLE_CODE, "Accounts Payable", AccountType.LIABILITY),
          new Seed("2010", "Accrued Liabilities", AccountType.LIABILITY),
          new Seed(TAX_PAYABLE_CODE, "SST/GST Payable", AccountType.LIABILITY),
          new Seed(DUE_TO_OWNER_CODE, "Due to Owner", AccountType.LIABILITY),
          new Seed("2100", "Loans Payable", AccountType.LIABILITY),
          new Seed(OWNER_CAPITAL_CODE, "Owner's Capital", AccountType.EQUITY),
          new Seed("3010", "Retained Earnings", AccountType.EQUITY),
          new Seed(OWNER_DRAWINGS_CODE, "Owner's Drawings", AccountType.EQUITY),
          new Seed(SALES_REVENUE_CODE, "Sales Revenue", AccountType.REVENUE),
          new Seed("4010", "Service Revenue", AccountType.REVENUE),
          new Seed("4900", "Other Income", AccountType.REVENUE),
          new Seed(
              GAIN_LOSS_ON_DISPOSAL_CODE, "Gain/Loss on Disposal of Assets", AccountType.REVENUE),
          new Seed("5000", "Cost of Goods Sold", AccountType.EXPENSE),
          new Seed("6000", "Rent Expense", AccountType.EXPENSE),
          new Seed("6010", "Utilities Expense", AccountType.EXPENSE),
          new Seed("6020", "Salaries Expense", AccountType.EXPENSE),
          new Seed("6030", "Office Supplies Expense", AccountType.EXPENSE),
          new Seed("6040", "Bank Charges & Fees", AccountType.EXPENSE),
          new Seed("6050", "Professional Fees", AccountType.EXPENSE),
          new Seed(DEPRECIATION_EXPENSE_CODE, "Depreciation Expense", AccountType.EXPENSE),
          new Seed(DEFAULT_EXPENSE_CODE, "Other Operating Expenses", AccountType.EXPENSE));

  private DefaultChartOfAccounts() {}
}
