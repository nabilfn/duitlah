package com.duitlah.api.sales;

import com.duitlah.api.catalog.ProductService;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.crm.CustomerService;
import com.duitlah.api.recurring.RecurrenceCalculator;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * "Recurring invoices" (V2 Phase 13) — the {@code sales} mirror of {@code
 * recurring.RecurringTransactionService}: a schedule (the rule) that {@link #materializeAllDue}
 * turns into real {@link Invoice} rows over time, reusing {@code recurring.RecurrenceCalculator}
 * directly rather than a second copy of the same date arithmetic.
 */
@Service
public class RecurringInvoiceService {

  private final RecurringInvoiceRepository recurringInvoices;
  private final RecurringInvoiceLineItemRepository lineItems;
  private final SpaceService spaceService;
  private final CustomerService customerService;
  private final ProductService productService;
  private final InvoiceService invoiceService;

  public RecurringInvoiceService(
      RecurringInvoiceRepository recurringInvoices,
      RecurringInvoiceLineItemRepository lineItems,
      SpaceService spaceService,
      CustomerService customerService,
      ProductService productService,
      InvoiceService invoiceService) {
    this.recurringInvoices = recurringInvoices;
    this.lineItems = lineItems;
    this.spaceService = spaceService;
    this.customerService = customerService;
    this.productService = productService;
    this.invoiceService = invoiceService;
  }

  @Transactional
  public RecurringInvoiceResponse create(
      UUID userId, UUID spaceId, CreateRecurringInvoiceRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SALES_DOCUMENTS);
    customerService.requireOwned(spaceId, request.customerId());

    RecurringInvoice rule =
        new RecurringInvoice(
            spaceId,
            request.customerId(),
            userId,
            request.taxPercentOrZero(),
            request.notes(),
            request.paymentTermDaysOrDefault(),
            request.frequency(),
            request.intervalCountOrDefault(),
            request.startDate(),
            request.endDate());
    recurringInvoices.save(rule);

    List<RecurringInvoiceLineItem> saved =
        saveLineItems(spaceId, rule.getId(), request.lineItems());
    return RecurringInvoiceResponse.of(
        rule, saved.stream().map(RecurringInvoiceLineItemResponse::of).toList());
  }

  public List<RecurringInvoiceResponse> list(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return recurringInvoices.findBySpaceIdOrderByNextOccurrenceDateAsc(spaceId).stream()
        .map(rule -> RecurringInvoiceResponse.of(rule, lineItemResponses(rule.getId())))
        .toList();
  }

  public RecurringInvoiceResponse get(UUID userId, UUID spaceId, UUID recurringInvoiceId) {
    spaceService.requireMembership(userId, spaceId);
    RecurringInvoice rule = requireOwned(spaceId, recurringInvoiceId);
    return RecurringInvoiceResponse.of(rule, lineItemResponses(rule.getId()));
  }

  @Transactional
  public RecurringInvoiceResponse setActive(
      UUID userId, UUID spaceId, UUID recurringInvoiceId, boolean active) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SALES_DOCUMENTS);
    RecurringInvoice rule = requireOwned(spaceId, recurringInvoiceId);
    rule.setActive(active);
    recurringInvoices.save(rule);
    return RecurringInvoiceResponse.of(rule, lineItemResponses(rule.getId()));
  }

  @Transactional
  public void delete(UUID userId, UUID spaceId, UUID recurringInvoiceId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SALES_DOCUMENTS);
    RecurringInvoice rule = requireOwned(spaceId, recurringInvoiceId);
    lineItems.deleteByRecurringInvoiceId(rule.getId());
    recurringInvoices.delete(rule);
  }

  /**
   * Materializes every elapsed occurrence of every active rule due on or before {@code asOf},
   * advancing each rule's {@code nextOccurrenceDate} as it goes — same catch-up-loop shape as
   * {@code recurring.RecurringTransactionService#materializeAllDue}, invoked daily by {@link
   * RecurringInvoiceScheduler}. Every materialized invoice is created {@code DRAFT} (see {@link
   * InvoiceService#createFromRecurring}) under the rule's own {@link
   * RecurringInvoice#getCreatedByUserId()} as the acting user, since a background job has no
   * request-scoped user of its own.
   */
  @Transactional
  public int materializeAllDue(LocalDate asOf) {
    List<RecurringInvoice> due =
        recurringInvoices.findByActiveTrueAndNextOccurrenceDateLessThanEqual(asOf);
    int created = 0;
    for (RecurringInvoice rule : due) {
      List<RecurringInvoiceLineItem> templateLines =
          lineItems.findByRecurringInvoiceIdOrderBySortOrderAsc(rule.getId());
      while (rule.isActive() && !rule.getNextOccurrenceDate().isAfter(asOf)) {
        LocalDate issueDate = rule.getNextOccurrenceDate();
        invoiceService.createFromRecurring(
            rule, templateLines, issueDate, issueDate.plusDays(rule.getPaymentTermDays()));
        created++;

        LocalDate next =
            RecurrenceCalculator.advance(
                rule.getNextOccurrenceDate(), rule.getFrequency(), rule.getIntervalCount());
        rule.setNextOccurrenceDate(next);
        if (rule.getEndDate() != null && next.isAfter(rule.getEndDate())) {
          rule.setActive(false);
        }
      }
      recurringInvoices.save(rule);
    }
    return created;
  }

  private List<RecurringInvoiceLineItem> saveLineItems(
      UUID spaceId, UUID recurringInvoiceId, List<LineItemRequest> requests) {
    int order = 0;
    List<RecurringInvoiceLineItem> saved = new ArrayList<>();
    for (LineItemRequest item : requests) {
      if (item.productId() != null) {
        productService.requireOwned(spaceId, item.productId());
      }
      RecurringInvoiceLineItem line =
          new RecurringInvoiceLineItem(
              recurringInvoiceId,
              item.productId(),
              item.description(),
              item.quantity(),
              item.unitPrice(),
              order++);
      lineItems.save(line);
      saved.add(line);
    }
    return saved;
  }

  private List<RecurringInvoiceLineItemResponse> lineItemResponses(UUID recurringInvoiceId) {
    return lineItems.findByRecurringInvoiceIdOrderBySortOrderAsc(recurringInvoiceId).stream()
        .map(RecurringInvoiceLineItemResponse::of)
        .toList();
  }

  private RecurringInvoice requireOwned(UUID spaceId, UUID recurringInvoiceId) {
    return recurringInvoices
        .findByIdAndSpaceId(recurringInvoiceId, spaceId)
        .orElseThrow(
            () ->
                new NotFoundException(
                    "RECURRING_INVOICE_NOT_FOUND", "Recurring invoice not found."));
  }
}
