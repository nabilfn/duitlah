package com.duitlah.api.sales;

import com.duitlah.api.catalog.ProductService;
import com.duitlah.api.common.error.ConflictException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.crm.CustomerService;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class QuotationService {

  private final QuotationRepository quotations;
  private final QuotationLineItemRepository lineItems;
  private final SpaceService spaceService;
  private final CustomerService customerService;
  private final ProductService productService;
  private final InvoiceService invoiceService;

  public QuotationService(
      QuotationRepository quotations,
      QuotationLineItemRepository lineItems,
      SpaceService spaceService,
      CustomerService customerService,
      ProductService productService,
      InvoiceService invoiceService) {
    this.quotations = quotations;
    this.lineItems = lineItems;
    this.spaceService = spaceService;
    this.customerService = customerService;
    this.productService = productService;
    this.invoiceService = invoiceService;
  }

  @Transactional
  public QuotationResponse create(UUID userId, UUID spaceId, CreateQuotationRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SALES_DOCUMENTS);
    customerService.requireOwned(spaceId, request.customerId());

    Quotation quotation =
        new Quotation(
            spaceId,
            request.customerId(),
            nextQuoteNumber(spaceId),
            request.issueDate(),
            request.expiryDate(),
            request.taxPercentOrZero());
    quotations.save(quotation);

    List<QuotationLineItem> saved = saveLineItems(spaceId, quotation.getId(), request.lineItems());
    applyTotals(quotation, saved);
    quotations.save(quotation);

    return QuotationResponse.of(quotation, saved.stream().map(LineItemResponse::of).toList());
  }

  public List<QuotationResponse> list(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return quotations.findBySpaceIdOrderByIssueDateDesc(spaceId).stream()
        .map(q -> QuotationResponse.of(q, lineItemResponses(q.getId())))
        .toList();
  }

  public QuotationResponse get(UUID userId, UUID spaceId, UUID quotationId) {
    spaceService.requireMembership(userId, spaceId);
    Quotation quotation = requireOwned(spaceId, quotationId);
    return QuotationResponse.of(quotation, lineItemResponses(quotationId));
  }

  @Transactional
  public QuotationResponse changeStatus(
      UUID userId, UUID spaceId, UUID quotationId, ChangeQuotationStatusRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SALES_DOCUMENTS);
    Quotation quotation = requireOwned(spaceId, quotationId);
    quotation.setStatus(request.status());
    quotations.save(quotation);
    return QuotationResponse.of(quotation, lineItemResponses(quotationId));
  }

  /** Creates a new DRAFT invoice from an ACCEPTED quotation, copying customer/lines/tax over. */
  @Transactional
  public InvoiceResponse convertToInvoice(
      UUID userId, UUID spaceId, UUID quotationId, java.time.LocalDate dueDate) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_SALES_DOCUMENTS);
    Quotation quotation = requireOwned(spaceId, quotationId);
    if (quotation.getStatus() != QuotationStatus.ACCEPTED) {
      throw new ConflictException(
          "QUOTATION_NOT_ACCEPTED", "Only an accepted quotation can be converted to an invoice.");
    }
    List<QuotationLineItem> lines = lineItems.findByQuotationIdOrderBySortOrderAsc(quotationId);
    return invoiceService.createFromQuotation(spaceId, quotation, lines, dueDate);
  }

  private List<QuotationLineItem> saveLineItems(
      UUID spaceId, UUID quotationId, List<LineItemRequest> requests) {
    int order = 0;
    List<QuotationLineItem> saved = new java.util.ArrayList<>();
    for (LineItemRequest item : requests) {
      if (item.productId() != null) {
        productService.requireOwned(spaceId, item.productId());
      }
      QuotationLineItem line =
          new QuotationLineItem(
              quotationId,
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

  private void applyTotals(Quotation quotation, List<QuotationLineItem> lines) {
    BigDecimal subtotal =
        lines.stream()
            .map(QuotationLineItem::getLineTotal)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
    BigDecimal taxAmount =
        subtotal
            .multiply(quotation.getTaxPercent())
            .divide(BigDecimal.valueOf(100), 2, java.math.RoundingMode.HALF_UP);
    quotation.setSubtotal(subtotal);
    quotation.setTaxAmount(taxAmount);
    quotation.setTotal(subtotal.add(taxAmount));
  }

  private List<LineItemResponse> lineItemResponses(UUID quotationId) {
    return lineItems.findByQuotationIdOrderBySortOrderAsc(quotationId).stream()
        .map(LineItemResponse::of)
        .toList();
  }

  private String nextQuoteNumber(UUID spaceId) {
    long count = quotations.countBySpaceId(spaceId) + 1;
    return "Q-%05d".formatted(count);
  }

  public Quotation requireOwned(UUID spaceId, UUID quotationId) {
    return quotations
        .findByIdAndSpaceId(quotationId, spaceId)
        .orElseThrow(() -> new NotFoundException("QUOTATION_NOT_FOUND", "Quotation not found."));
  }
}
