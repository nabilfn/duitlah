package com.duitlah.api.einvoice;

import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.crm.Customer;
import com.duitlah.api.crm.CustomerService;
import com.duitlah.api.sales.Invoice;
import com.duitlah.api.sales.InvoiceLineItem;
import com.duitlah.api.sales.InvoiceLineItemRepository;
import com.duitlah.api.spaces.BusinessProfile;
import com.duitlah.api.spaces.SpaceService;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

/**
 * Section 56: "Eligibility / Required Fields -> Customer TIN validation -> Generate MyInvois
 * payload." Reuses the invoice's own already-computed subtotal/taxAmount/total (Phase 5) rather
 * than recalculating anything.
 */
@Service
public class EInvoicePayloadBuilder {

  private final SpaceService spaceService;
  private final CustomerService customerService;
  private final InvoiceLineItemRepository lineItems;

  public EInvoicePayloadBuilder(
      SpaceService spaceService,
      CustomerService customerService,
      InvoiceLineItemRepository lineItems) {
    this.spaceService = spaceService;
    this.customerService = customerService;
    this.lineItems = lineItems;
  }

  /**
   * Throws {@code 400 EINVOICE_SELLER_TIN_MISSING}/{@code EINVOICE_BUYER_TIN_MISSING} if either
   * party's TIN is absent — this is the workflow's "Customer TIN validation" step.
   */
  public EInvoicePayload build(UUID spaceId, Invoice invoice) {
    BusinessProfile seller = spaceService.requireBusinessProfile(spaceId);
    if (isBlank(seller.getTin())) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "EINVOICE_SELLER_TIN_MISSING",
          "Add your business's TIN in Business Settings before submitting an e-Invoice.");
    }
    Customer buyer = customerService.requireOwned(spaceId, invoice.getCustomerId());
    if (isBlank(buyer.getTin())) {
      throw new ApiException(
          HttpStatus.BAD_REQUEST,
          "EINVOICE_BUYER_TIN_MISSING",
          "Add a TIN for this customer before submitting an e-Invoice.");
    }

    List<EInvoicePayload.EInvoicePayloadLine> lines =
        lineItems.findByInvoiceIdOrderBySortOrderAsc(invoice.getId()).stream()
            .map(this::toPayloadLine)
            .toList();

    return new EInvoicePayload(
        seller.getTin(),
        seller.getLegalName(),
        seller.getRegistrationNumber(),
        buyer.getTin(),
        buyer.getName(),
        buyer.getRegistrationNumber(),
        invoice.getInvoiceNumber(),
        invoice.getIssueDate(),
        seller.getCurrency(),
        invoice.getSubtotal(),
        invoice.getTaxAmount(),
        invoice.getTotal(),
        lines);
  }

  private EInvoicePayload.EInvoicePayloadLine toPayloadLine(InvoiceLineItem item) {
    return new EInvoicePayload.EInvoicePayloadLine(
        item.getDescription(), item.getQuantity(), item.getUnitPrice(), item.getLineTotal());
  }

  private boolean isBlank(String value) {
    return value == null || value.isBlank();
  }
}
