package com.duitlah.api.sales;

import com.duitlah.api.accounting.AutomaticPostingService;
import com.duitlah.api.bizbanking.BusinessAccount;
import com.duitlah.api.bizbanking.BusinessAccountService;
import com.duitlah.api.catalog.Product;
import com.duitlah.api.catalog.ProductService;
import com.duitlah.api.common.error.ConflictException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.crm.CustomerService;
import com.duitlah.api.inventory.InventoryMovementService;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Invoice.status only ever holds DRAFT/SENT/VOID — {@link InvoiceEffectiveStatus} (which also
 * covers PARTIALLY_PAID/PAID/OVERDUE) is computed fresh in every response, never stored. See
 * package-info.
 */
@Service
public class InvoiceService {

  private final InvoiceRepository invoices;
  private final InvoiceLineItemRepository lineItems;
  private final InvoicePaymentRepository payments;
  private final CreditNoteRepository creditNotes;
  private final SpaceService spaceService;
  private final CustomerService customerService;
  private final ProductService productService;
  private final BusinessAccountService businessAccountService;
  private final AutomaticPostingService automaticPostingService;
  private final InventoryMovementService inventoryMovementService;

  public InvoiceService(
      InvoiceRepository invoices,
      InvoiceLineItemRepository lineItems,
      InvoicePaymentRepository payments,
      CreditNoteRepository creditNotes,
      SpaceService spaceService,
      CustomerService customerService,
      ProductService productService,
      BusinessAccountService businessAccountService,
      AutomaticPostingService automaticPostingService,
      InventoryMovementService inventoryMovementService) {
    this.invoices = invoices;
    this.lineItems = lineItems;
    this.payments = payments;
    this.creditNotes = creditNotes;
    this.spaceService = spaceService;
    this.customerService = customerService;
    this.productService = productService;
    this.businessAccountService = businessAccountService;
    this.automaticPostingService = automaticPostingService;
    this.inventoryMovementService = inventoryMovementService;
  }

  @Transactional
  public InvoiceResponse create(UUID userId, UUID spaceId, CreateInvoiceRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SALES_DOCUMENTS);
    customerService.requireOwned(spaceId, request.customerId());

    Invoice invoice =
        new Invoice(
            spaceId,
            request.customerId(),
            nextInvoiceNumber(spaceId),
            request.issueDate(),
            request.dueDate(),
            request.taxPercentOrZero());
    invoices.save(invoice);

    List<InvoiceLineItem> saved = saveLineItems(spaceId, invoice.getId(), request.lineItems());
    applyTotals(invoice, saved);
    invoices.save(invoice);

    return toResponse(invoice, saved.stream().map(LineItemResponse::of).toList());
  }

  /** Called by {@code QuotationService.convertToInvoice} — permission already checked there. */
  @Transactional
  InvoiceResponse createFromQuotation(
      UUID spaceId,
      Quotation quotation,
      List<QuotationLineItem> quotationLines,
      LocalDate dueDate) {
    Invoice invoice =
        new Invoice(
            spaceId,
            quotation.getCustomerId(),
            nextInvoiceNumber(spaceId),
            quotation.getIssueDate(),
            dueDate,
            quotation.getTaxPercent());
    invoice.setConvertedFromQuotationId(quotation.getId());
    invoice.setNotes(quotation.getNotes());
    invoices.save(invoice);

    List<InvoiceLineItem> saved = new ArrayList<>();
    int order = 0;
    for (QuotationLineItem line : quotationLines) {
      InvoiceLineItem copy =
          new InvoiceLineItem(
              invoice.getId(),
              line.getProductId(),
              line.getDescription(),
              line.getQuantity(),
              line.getUnitPrice(),
              order++);
      lineItems.save(copy);
      saved.add(copy);
    }
    applyTotals(invoice, saved);
    invoices.save(invoice);

    return toResponse(invoice, saved.stream().map(LineItemResponse::of).toList());
  }

  /**
   * Called by {@code RecurringInvoiceService.materializeAllDue} — the recurring-invoice mirror of
   * {@link #createFromQuotation}. Always {@code DRAFT}: a recurring schedule materializing a real
   * invoice doesn't imply the business has reviewed it yet, so this never auto-sends (never posts
   * to accounting or moves inventory) the way {@link #changeStatus} to {@code SENT} does.
   */
  @Transactional
  InvoiceResponse createFromRecurring(
      RecurringInvoice rule,
      List<RecurringInvoiceLineItem> templateLines,
      LocalDate issueDate,
      LocalDate dueDate) {
    Invoice invoice =
        new Invoice(
            rule.getSpaceId(),
            rule.getCustomerId(),
            nextInvoiceNumber(rule.getSpaceId()),
            issueDate,
            dueDate,
            rule.getTaxPercent());
    invoice.setSourceRecurringInvoiceId(rule.getId());
    invoice.setNotes(rule.getNotes());
    invoices.save(invoice);

    List<InvoiceLineItem> saved = new ArrayList<>();
    int order = 0;
    for (RecurringInvoiceLineItem line : templateLines) {
      InvoiceLineItem copy =
          new InvoiceLineItem(
              invoice.getId(),
              line.getProductId(),
              line.getDescription(),
              line.getQuantity(),
              line.getUnitPrice(),
              order++);
      lineItems.save(copy);
      saved.add(copy);
    }
    applyTotals(invoice, saved);
    invoices.save(invoice);

    return toResponse(invoice, saved.stream().map(LineItemResponse::of).toList());
  }

  public List<InvoiceResponse> list(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return invoices.findBySpaceIdOrderByIssueDateDesc(spaceId).stream()
        .map(invoice -> toResponse(invoice, lineItemResponses(invoice.getId())))
        .toList();
  }

  public InvoiceResponse get(UUID userId, UUID spaceId, UUID invoiceId) {
    spaceService.requireMembership(userId, spaceId);
    Invoice invoice = requireOwned(spaceId, invoiceId);
    return toResponse(invoice, lineItemResponses(invoiceId));
  }

  @Transactional
  public InvoiceResponse changeStatus(
      UUID userId, UUID spaceId, UUID invoiceId, ChangeInvoiceStatusRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SALES_DOCUMENTS);
    Invoice invoice = requireOwned(spaceId, invoiceId);
    boolean newlySent =
        invoice.getStatus() != InvoiceStatus.SENT && request.status() == InvoiceStatus.SENT;
    invoice.setStatus(request.status());
    invoices.save(invoice);
    if (newlySent) {
      automaticPostingService.postInvoiceIssued(
          spaceId,
          userId,
          invoice.getId(),
          invoice.getIssueDate(),
          invoice.getSubtotal(),
          invoice.getTaxAmount(),
          "Invoice " + invoice.getInvoiceNumber());
      for (InvoiceLineItem line : lineItems.findByInvoiceIdOrderBySortOrderAsc(invoiceId)) {
        if (line.getProductId() == null) {
          continue;
        }
        Product product = productService.requireOwned(spaceId, line.getProductId());
        if (product.isTrackInventory()) {
          inventoryMovementService.recordSaleFromInvoice(
              spaceId,
              userId,
              product.getId(),
              line.getQuantity(),
              invoice.getIssueDate(),
              line.getId());
        }
      }
    }
    return toResponse(invoice, lineItemResponses(invoiceId));
  }

  public List<InvoicePaymentResponse> listPayments(UUID userId, UUID spaceId, UUID invoiceId) {
    spaceService.requireMembership(userId, spaceId);
    requireOwned(spaceId, invoiceId);
    return payments.findByInvoiceIdOrderByPaidOnDesc(invoiceId).stream()
        .map(InvoicePaymentResponse::of)
        .toList();
  }

  @Transactional
  public InvoicePaymentResponse recordPayment(
      UUID userId, UUID spaceId, UUID invoiceId, RecordInvoicePaymentRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.RECORD_PAYMENTS);
    Invoice invoice = requireOwned(spaceId, invoiceId);
    if (invoice.getStatus() == InvoiceStatus.VOID) {
      throw new ConflictException("INVOICE_VOID", "A void invoice can't receive payments.");
    }
    BusinessAccount businessAccount =
        businessAccountService.requireOwned(spaceId, request.businessAccountId());

    InvoicePayment payment =
        new InvoicePayment(
            invoiceId,
            request.businessAccountId(),
            request.amount(),
            request.paidOn(),
            request.notes());
    payments.save(payment);

    String description = "Invoice payment: " + invoice.getInvoiceNumber();
    businessAccountService.recordInvoicePayment(
        request.businessAccountId(),
        request.amount(),
        request.paidOn(),
        description,
        payment.getId());
    automaticPostingService.postInvoicePayment(
        spaceId,
        userId,
        payment.getId(),
        request.paidOn(),
        request.amount(),
        description,
        businessAccount.getChartOfAccountsId());

    return InvoicePaymentResponse.of(payment);
  }

  private List<InvoiceLineItem> saveLineItems(
      UUID spaceId, UUID invoiceId, List<LineItemRequest> requests) {
    int order = 0;
    List<InvoiceLineItem> saved = new ArrayList<>();
    for (LineItemRequest item : requests) {
      if (item.productId() != null) {
        productService.requireOwned(spaceId, item.productId());
      }
      InvoiceLineItem line =
          new InvoiceLineItem(
              invoiceId,
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

  private void applyTotals(Invoice invoice, List<InvoiceLineItem> lines) {
    BigDecimal subtotal =
        lines.stream().map(InvoiceLineItem::getLineTotal).reduce(BigDecimal.ZERO, BigDecimal::add);
    BigDecimal taxAmount =
        subtotal
            .multiply(invoice.getTaxPercent())
            .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
    invoice.setSubtotal(subtotal);
    invoice.setTaxAmount(taxAmount);
    invoice.setTotal(subtotal.add(taxAmount));
  }

  private List<LineItemResponse> lineItemResponses(UUID invoiceId) {
    return lineItems.findByInvoiceIdOrderBySortOrderAsc(invoiceId).stream()
        .map(LineItemResponse::of)
        .toList();
  }

  private InvoiceResponse toResponse(Invoice invoice, List<LineItemResponse> lines) {
    BigDecimal amountPaid = payments.sumAmountByInvoiceId(invoice.getId());
    BigDecimal amountCredited = creditNotes.sumIssuedAmountByInvoiceId(invoice.getId());
    BigDecimal outstanding =
        invoice.getTotal().subtract(amountPaid).subtract(amountCredited).max(BigDecimal.ZERO);

    InvoiceEffectiveStatus effectiveStatus;
    if (invoice.getStatus() == InvoiceStatus.VOID) {
      effectiveStatus = InvoiceEffectiveStatus.VOID;
    } else if (outstanding.signum() <= 0) {
      effectiveStatus = InvoiceEffectiveStatus.PAID;
    } else if (amountPaid.signum() > 0 || amountCredited.signum() > 0) {
      effectiveStatus = InvoiceEffectiveStatus.PARTIALLY_PAID;
    } else if (invoice.getStatus() == InvoiceStatus.SENT
        && invoice.getDueDate().isBefore(LocalDate.now())) {
      effectiveStatus = InvoiceEffectiveStatus.OVERDUE;
    } else {
      effectiveStatus =
          invoice.getStatus() == InvoiceStatus.SENT
              ? InvoiceEffectiveStatus.SENT
              : InvoiceEffectiveStatus.DRAFT;
    }

    return InvoiceResponse.of(
        invoice, effectiveStatus, amountPaid, amountCredited, outstanding, lines);
  }

  private String nextInvoiceNumber(UUID spaceId) {
    long count = invoices.countBySpaceId(spaceId) + 1;
    return "INV-%05d".formatted(count);
  }

  public Invoice requireOwned(UUID spaceId, UUID invoiceId) {
    return invoices
        .findByIdAndSpaceId(invoiceId, spaceId)
        .orElseThrow(() -> new NotFoundException("INVOICE_NOT_FOUND", "Invoice not found."));
  }
}
