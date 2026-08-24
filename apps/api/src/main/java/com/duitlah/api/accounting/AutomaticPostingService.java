package com.duitlah.api.accounting;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Turns a completed business action into a real journal entry, matching spec section 36 literally:
 * an ordinary user sees "Record Expense" / "Receive Payment" / "Pay Supplier", never a debit/credit
 * form. Every method here is a deliberate best-effort no-op — see the module's own package-info —
 * whenever a required mapping is missing, since a space that hasn't set up its books yet must keep
 * using Phase 5's expense/invoice/banking features exactly as before.
 */
@Service
public class AutomaticPostingService {

  private final JournalEntryService journalEntryService;
  private final ChartOfAccountsService chartOfAccounts;
  private final JournalEntryRepository journalEntries;

  public AutomaticPostingService(
      JournalEntryService journalEntryService,
      ChartOfAccountsService chartOfAccounts,
      JournalEntryRepository journalEntries) {
    this.journalEntryService = journalEntryService;
    this.chartOfAccounts = chartOfAccounts;
    this.journalEntries = journalEntries;
  }

  /**
   * Debit the expense's mapped account (or the default Other Operating Expenses account); credit
   * the paying business account's mapped ledger account. Skipped if the business account has no
   * mapping.
   */
  @Transactional
  public void postExpensePayment(
      UUID spaceId,
      UUID userId,
      UUID expensePaymentId,
      LocalDate paidOn,
      BigDecimal amount,
      String description,
      UUID expenseChartOfAccountsId,
      UUID businessAccountChartOfAccountsId) {
    if (alreadyPosted(spaceId, JournalSourceType.EXPENSE_PAYMENT, expensePaymentId)) {
      return;
    }
    Optional<UUID> expenseAccount =
        expenseChartOfAccountsId != null
            ? Optional.of(expenseChartOfAccountsId)
            : chartOfAccounts
                .findByCode(spaceId, DefaultChartOfAccounts.DEFAULT_EXPENSE_CODE)
                .map(LedgerAccount::getId);
    if (expenseAccount.isEmpty() || businessAccountChartOfAccountsId == null) {
      return;
    }
    List<JournalLineRequest> lines = new ArrayList<>();
    lines.add(
        new JournalLineRequest(expenseAccount.get(), JournalDirection.DEBIT, amount, description));
    lines.add(
        new JournalLineRequest(
            businessAccountChartOfAccountsId, JournalDirection.CREDIT, amount, description));
    journalEntryService.post(
        spaceId,
        paidOn,
        description,
        JournalSourceType.EXPENSE_PAYMENT,
        expensePaymentId,
        userId,
        lines);
  }

  /**
   * Debit the receiving business account's mapped ledger account; credit the system Accounts
   * Receivable account. Skipped if either mapping is missing.
   */
  @Transactional
  public void postInvoicePayment(
      UUID spaceId,
      UUID userId,
      UUID invoicePaymentId,
      LocalDate paidOn,
      BigDecimal amount,
      String description,
      UUID businessAccountChartOfAccountsId) {
    if (alreadyPosted(spaceId, JournalSourceType.INVOICE_PAYMENT, invoicePaymentId)) {
      return;
    }
    Optional<UUID> receivable =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.ACCOUNTS_RECEIVABLE_CODE)
            .map(LedgerAccount::getId);
    if (receivable.isEmpty() || businessAccountChartOfAccountsId == null) {
      return;
    }
    List<JournalLineRequest> lines =
        List.of(
            new JournalLineRequest(
                businessAccountChartOfAccountsId, JournalDirection.DEBIT, amount, description),
            new JournalLineRequest(receivable.get(), JournalDirection.CREDIT, amount, description));
    journalEntryService.post(
        spaceId,
        paidOn,
        description,
        JournalSourceType.INVOICE_PAYMENT,
        invoicePaymentId,
        userId,
        lines);
  }

  /**
   * Debit Accounts Receivable for the invoice total; credit Sales Revenue for the subtotal and, if
   * any tax was charged, SST/GST Payable for the tax portion. Fires once, on the DRAFT→SENT
   * transition. Skipped if the system accounts aren't present (no chart of accounts seeded).
   */
  @Transactional
  public void postInvoiceIssued(
      UUID spaceId,
      UUID userId,
      UUID invoiceId,
      LocalDate issueDate,
      BigDecimal subtotal,
      BigDecimal taxAmount,
      String description) {
    if (alreadyPosted(spaceId, JournalSourceType.INVOICE_ISSUED, invoiceId)) {
      return;
    }
    Optional<UUID> receivable =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.ACCOUNTS_RECEIVABLE_CODE)
            .map(LedgerAccount::getId);
    Optional<UUID> revenue =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.SALES_REVENUE_CODE)
            .map(LedgerAccount::getId);
    if (receivable.isEmpty() || revenue.isEmpty()) {
      return;
    }
    BigDecimal total = subtotal.add(taxAmount);
    List<JournalLineRequest> lines = new ArrayList<>();
    lines.add(new JournalLineRequest(receivable.get(), JournalDirection.DEBIT, total, description));
    lines.add(
        new JournalLineRequest(revenue.get(), JournalDirection.CREDIT, subtotal, description));
    if (taxAmount.signum() > 0) {
      Optional<UUID> taxPayable =
          chartOfAccounts
              .findByCode(spaceId, DefaultChartOfAccounts.TAX_PAYABLE_CODE)
              .map(LedgerAccount::getId);
      if (taxPayable.isEmpty()) {
        return;
      }
      lines.add(
          new JournalLineRequest(
              taxPayable.get(), JournalDirection.CREDIT, taxAmount, description));
    }
    journalEntryService.post(
        spaceId,
        issueDate,
        description,
        JournalSourceType.INVOICE_ISSUED,
        invoiceId,
        userId,
        lines);
  }

  /**
   * A credit note reverses part of the previously recognized revenue: debit Sales Revenue, credit
   * Accounts Receivable.
   */
  @Transactional
  public void postCreditNote(
      UUID spaceId,
      UUID userId,
      UUID creditNoteId,
      LocalDate issueDate,
      BigDecimal amount,
      String description) {
    if (alreadyPosted(spaceId, JournalSourceType.CREDIT_NOTE, creditNoteId)) {
      return;
    }
    Optional<UUID> receivable =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.ACCOUNTS_RECEIVABLE_CODE)
            .map(LedgerAccount::getId);
    Optional<UUID> revenue =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.SALES_REVENUE_CODE)
            .map(LedgerAccount::getId);
    if (receivable.isEmpty() || revenue.isEmpty()) {
      return;
    }
    List<JournalLineRequest> lines =
        List.of(
            new JournalLineRequest(revenue.get(), JournalDirection.DEBIT, amount, description),
            new JournalLineRequest(receivable.get(), JournalDirection.CREDIT, amount, description));
    journalEntryService.post(
        spaceId,
        issueDate,
        description,
        JournalSourceType.CREDIT_NOTE,
        creditNoteId,
        userId,
        lines);
  }

  /**
   * V2 Phase 8 — debit Inventory for the purchase cost; credit the paying business account's mapped
   * ledger account if one was specified, otherwise Accounts Payable (bought on credit, to be paid
   * later). Skipped if the amount is zero (no unit cost recorded yet) or a required account is
   * missing.
   */
  @Transactional
  public void postInventoryPurchase(
      UUID spaceId,
      UUID userId,
      UUID movementId,
      LocalDate occurredOn,
      BigDecimal amount,
      String description,
      UUID businessAccountChartOfAccountsId) {
    if (amount.signum() <= 0
        || alreadyPosted(spaceId, JournalSourceType.INVENTORY_PURCHASE, movementId)) {
      return;
    }
    Optional<UUID> inventory =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.INVENTORY_CODE)
            .map(LedgerAccount::getId);
    if (inventory.isEmpty()) {
      return;
    }
    UUID creditAccountId;
    if (businessAccountChartOfAccountsId != null) {
      creditAccountId = businessAccountChartOfAccountsId;
    } else {
      Optional<UUID> payable =
          chartOfAccounts
              .findByCode(spaceId, DefaultChartOfAccounts.ACCOUNTS_PAYABLE_CODE)
              .map(LedgerAccount::getId);
      if (payable.isEmpty()) {
        return;
      }
      creditAccountId = payable.get();
    }
    List<JournalLineRequest> lines =
        List.of(
            new JournalLineRequest(inventory.get(), JournalDirection.DEBIT, amount, description),
            new JournalLineRequest(creditAccountId, JournalDirection.CREDIT, amount, description));
    journalEntryService.post(
        spaceId,
        occurredOn,
        description,
        JournalSourceType.INVENTORY_PURCHASE,
        movementId,
        userId,
        lines);
  }

  /**
   * V2 Phase 8 — debit Cost of Goods Sold, credit Inventory, for a sale's locked-in Weighted
   * Average Cost. Skipped if the amount is zero or either system account is missing.
   */
  @Transactional
  public void postCogs(
      UUID spaceId,
      UUID userId,
      UUID movementId,
      LocalDate occurredOn,
      BigDecimal amount,
      String description) {
    if (amount.signum() <= 0
        || alreadyPosted(spaceId, JournalSourceType.INVENTORY_COGS, movementId)) {
      return;
    }
    Optional<UUID> cogs =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.COGS_CODE)
            .map(LedgerAccount::getId);
    Optional<UUID> inventory =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.INVENTORY_CODE)
            .map(LedgerAccount::getId);
    if (cogs.isEmpty() || inventory.isEmpty()) {
      return;
    }
    List<JournalLineRequest> lines =
        List.of(
            new JournalLineRequest(cogs.get(), JournalDirection.DEBIT, amount, description),
            new JournalLineRequest(inventory.get(), JournalDirection.CREDIT, amount, description));
    journalEntryService.post(
        spaceId,
        occurredOn,
        description,
        JournalSourceType.INVENTORY_COGS,
        movementId,
        userId,
        lines);
  }

  /**
   * V2 Phase 9 — debit Fixed Assets for the acquisition cost; credit the paying business account's
   * mapped ledger account if one was specified, otherwise Accounts Payable (bought on credit). Same
   * shape as {@link #postInventoryPurchase}.
   */
  @Transactional
  public void postAssetAcquired(
      UUID spaceId,
      UUID userId,
      UUID assetId,
      LocalDate acquisitionDate,
      BigDecimal cost,
      String description,
      UUID businessAccountChartOfAccountsId) {
    if (alreadyPosted(spaceId, JournalSourceType.ASSET_ACQUIRED, assetId)) {
      return;
    }
    Optional<UUID> fixedAssets =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.FIXED_ASSETS_CODE)
            .map(LedgerAccount::getId);
    if (fixedAssets.isEmpty()) {
      return;
    }
    UUID creditAccountId;
    if (businessAccountChartOfAccountsId != null) {
      creditAccountId = businessAccountChartOfAccountsId;
    } else {
      Optional<UUID> payable =
          chartOfAccounts
              .findByCode(spaceId, DefaultChartOfAccounts.ACCOUNTS_PAYABLE_CODE)
              .map(LedgerAccount::getId);
      if (payable.isEmpty()) {
        return;
      }
      creditAccountId = payable.get();
    }
    List<JournalLineRequest> lines =
        List.of(
            new JournalLineRequest(fixedAssets.get(), JournalDirection.DEBIT, cost, description),
            new JournalLineRequest(creditAccountId, JournalDirection.CREDIT, cost, description));
    journalEntryService.post(
        spaceId,
        acquisitionDate,
        description,
        JournalSourceType.ASSET_ACQUIRED,
        assetId,
        userId,
        lines);
  }

  /**
   * V2 Phase 9 — debit Depreciation Expense, credit Accumulated Depreciation, for one period's
   * computed depreciation amount.
   */
  @Transactional
  public void postAssetDepreciation(
      UUID spaceId,
      UUID userId,
      UUID depreciationEntryId,
      LocalDate periodDate,
      BigDecimal amount,
      String description) {
    if (amount.signum() <= 0
        || alreadyPosted(spaceId, JournalSourceType.ASSET_DEPRECIATION, depreciationEntryId)) {
      return;
    }
    Optional<UUID> expense =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.DEPRECIATION_EXPENSE_CODE)
            .map(LedgerAccount::getId);
    Optional<UUID> accumulated =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.ACCUMULATED_DEPRECIATION_CODE)
            .map(LedgerAccount::getId);
    if (expense.isEmpty() || accumulated.isEmpty()) {
      return;
    }
    List<JournalLineRequest> lines =
        List.of(
            new JournalLineRequest(expense.get(), JournalDirection.DEBIT, amount, description),
            new JournalLineRequest(
                accumulated.get(), JournalDirection.CREDIT, amount, description));
    journalEntryService.post(
        spaceId,
        periodDate,
        description,
        JournalSourceType.ASSET_DEPRECIATION,
        depreciationEntryId,
        userId,
        lines);
  }

  /**
   * V2 Phase 9 — removes a disposed asset from the books: credit Fixed Assets for its original
   * cost, debit Accumulated Depreciation to clear it, debit the receiving business account's mapped
   * ledger account for any proceeds, and post the remaining gain or loss (proceeds vs. net book
   * value) to Gain/Loss on Disposal. Skipped (best-effort, like every other automatic posting
   * method) if a required system account is missing, or if there are proceeds to record but no
   * mapped business account was given — the caller is expected to have already enforced that a
   * non-zero disposal always has a receiving account (see {@code assets.FixedAssetService}).
   */
  @Transactional
  public void postAssetDisposal(
      UUID spaceId,
      UUID userId,
      UUID assetId,
      LocalDate disposedOn,
      BigDecimal cost,
      BigDecimal accumulatedDepreciation,
      BigDecimal proceeds,
      String description,
      UUID businessAccountChartOfAccountsId) {
    if (alreadyPosted(spaceId, JournalSourceType.ASSET_DISPOSAL, assetId)) {
      return;
    }
    if (proceeds.signum() > 0 && businessAccountChartOfAccountsId == null) {
      return;
    }
    Optional<UUID> fixedAssets =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.FIXED_ASSETS_CODE)
            .map(LedgerAccount::getId);
    Optional<UUID> accumulated =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.ACCUMULATED_DEPRECIATION_CODE)
            .map(LedgerAccount::getId);
    Optional<UUID> gainLossAccount =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.GAIN_LOSS_ON_DISPOSAL_CODE)
            .map(LedgerAccount::getId);
    if (fixedAssets.isEmpty() || accumulated.isEmpty() || gainLossAccount.isEmpty()) {
      return;
    }
    BigDecimal netBookValue = cost.subtract(accumulatedDepreciation);
    BigDecimal gainOrLoss = proceeds.subtract(netBookValue);

    List<JournalLineRequest> lines = new ArrayList<>();
    if (accumulatedDepreciation.signum() > 0) {
      lines.add(
          new JournalLineRequest(
              accumulated.get(), JournalDirection.DEBIT, accumulatedDepreciation, description));
    }
    if (proceeds.signum() > 0) {
      lines.add(
          new JournalLineRequest(
              businessAccountChartOfAccountsId, JournalDirection.DEBIT, proceeds, description));
    }
    if (gainOrLoss.signum() < 0) {
      lines.add(
          new JournalLineRequest(
              gainLossAccount.get(), JournalDirection.DEBIT, gainOrLoss.abs(), description));
    }
    lines.add(
        new JournalLineRequest(fixedAssets.get(), JournalDirection.CREDIT, cost, description));
    if (gainOrLoss.signum() > 0) {
      lines.add(
          new JournalLineRequest(
              gainLossAccount.get(), JournalDirection.CREDIT, gainOrLoss, description));
    }
    journalEntryService.post(
        spaceId, disposedOn, description, JournalSourceType.ASSET_DISPOSAL, assetId, userId, lines);
  }

  /**
   * V2 Phase 11 — debit the chosen expense account, credit Due to Owner. Unlike a normal expense
   * payment, no business bank account is involved: the owner paid personally (spec section 58).
   * {@code expenseChartOfAccountsId} is always a real, already-validated account (the caller,
   * {@code crossspace.CrossSpaceService}, requires the Chart of Accounts to be properly set up
   * before attempting this — unlike every other method here, there is no cash-ledger fallback if
   * posting is skipped, so a silent no-op would leave nothing behind at all).
   */
  @Transactional
  public Optional<UUID> postBusinessAdvance(
      UUID spaceId,
      UUID userId,
      UUID linkId,
      LocalDate occurredOn,
      BigDecimal amount,
      String description,
      UUID expenseChartOfAccountsId) {
    if (alreadyPosted(spaceId, JournalSourceType.BUSINESS_ADVANCE, linkId)) {
      return Optional.empty();
    }
    Optional<UUID> dueToOwner =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.DUE_TO_OWNER_CODE)
            .map(LedgerAccount::getId);
    if (dueToOwner.isEmpty()) {
      return Optional.empty();
    }
    List<JournalLineRequest> lines =
        List.of(
            new JournalLineRequest(
                expenseChartOfAccountsId, JournalDirection.DEBIT, amount, description),
            new JournalLineRequest(dueToOwner.get(), JournalDirection.CREDIT, amount, description));
    JournalEntry entry =
        journalEntryService.post(
            spaceId,
            occurredOn,
            description,
            JournalSourceType.BUSINESS_ADVANCE,
            linkId,
            userId,
            lines);
    return Optional.of(entry.getId());
  }

  /**
   * V2 Phase 11 — debit Due to Owner (clearing the liability), credit the paying business account.
   * Never classified as a new business expense (spec section 58).
   */
  @Transactional
  public Optional<UUID> postReimbursement(
      UUID spaceId,
      UUID userId,
      UUID linkId,
      LocalDate occurredOn,
      BigDecimal amount,
      String description,
      UUID businessAccountChartOfAccountsId) {
    if (alreadyPosted(spaceId, JournalSourceType.REIMBURSEMENT, linkId)
        || businessAccountChartOfAccountsId == null) {
      return Optional.empty();
    }
    Optional<UUID> dueToOwner =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.DUE_TO_OWNER_CODE)
            .map(LedgerAccount::getId);
    if (dueToOwner.isEmpty()) {
      return Optional.empty();
    }
    List<JournalLineRequest> lines =
        List.of(
            new JournalLineRequest(dueToOwner.get(), JournalDirection.DEBIT, amount, description),
            new JournalLineRequest(
                businessAccountChartOfAccountsId, JournalDirection.CREDIT, amount, description));
    JournalEntry entry =
        journalEntryService.post(
            spaceId,
            occurredOn,
            description,
            JournalSourceType.REIMBURSEMENT,
            linkId,
            userId,
            lines);
    return Optional.of(entry.getId());
  }

  /**
   * V2 Phase 11 — debit the receiving business account, credit Owner's Capital. Never Business
   * Revenue (spec section 59).
   */
  @Transactional
  public Optional<UUID> postOwnerContribution(
      UUID spaceId,
      UUID userId,
      UUID linkId,
      LocalDate occurredOn,
      BigDecimal amount,
      String description,
      UUID businessAccountChartOfAccountsId) {
    if (alreadyPosted(spaceId, JournalSourceType.OWNER_CONTRIBUTION, linkId)
        || businessAccountChartOfAccountsId == null) {
      return Optional.empty();
    }
    Optional<UUID> ownerCapital =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.OWNER_CAPITAL_CODE)
            .map(LedgerAccount::getId);
    if (ownerCapital.isEmpty()) {
      return Optional.empty();
    }
    List<JournalLineRequest> lines =
        List.of(
            new JournalLineRequest(
                businessAccountChartOfAccountsId, JournalDirection.DEBIT, amount, description),
            new JournalLineRequest(
                ownerCapital.get(), JournalDirection.CREDIT, amount, description));
    JournalEntry entry =
        journalEntryService.post(
            spaceId,
            occurredOn,
            description,
            JournalSourceType.OWNER_CONTRIBUTION,
            linkId,
            userId,
            lines);
    return Optional.of(entry.getId());
  }

  /**
   * V2 Phase 11 — debit Owner's Drawings, credit the paying business account. Never a normal
   * business expense (spec section 60).
   */
  @Transactional
  public Optional<UUID> postOwnerDrawing(
      UUID spaceId,
      UUID userId,
      UUID linkId,
      LocalDate occurredOn,
      BigDecimal amount,
      String description,
      UUID businessAccountChartOfAccountsId) {
    if (alreadyPosted(spaceId, JournalSourceType.OWNER_DRAWING, linkId)
        || businessAccountChartOfAccountsId == null) {
      return Optional.empty();
    }
    Optional<UUID> ownerDrawings =
        chartOfAccounts
            .findByCode(spaceId, DefaultChartOfAccounts.OWNER_DRAWINGS_CODE)
            .map(LedgerAccount::getId);
    if (ownerDrawings.isEmpty()) {
      return Optional.empty();
    }
    List<JournalLineRequest> lines =
        List.of(
            new JournalLineRequest(
                ownerDrawings.get(), JournalDirection.DEBIT, amount, description),
            new JournalLineRequest(
                businessAccountChartOfAccountsId, JournalDirection.CREDIT, amount, description));
    JournalEntry entry =
        journalEntryService.post(
            spaceId,
            occurredOn,
            description,
            JournalSourceType.OWNER_DRAWING,
            linkId,
            userId,
            lines);
    return Optional.of(entry.getId());
  }

  private boolean alreadyPosted(UUID spaceId, JournalSourceType sourceType, UUID sourceId) {
    return journalEntries.existsBySpaceIdAndSourceTypeAndSourceId(spaceId, sourceType, sourceId);
  }
}
