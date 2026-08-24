package com.duitlah.api.receipts;

import com.duitlah.api.bagilah.AllocationStrategy;
import com.duitlah.api.bagilah.CreateReceiptItemRequest;
import jakarta.validation.Valid;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

/**
 * The user's reviewed-and-corrected version of what OCR read off the receipt (product spec section
 * 10: merchant, item names/prices/quantities, tax, service, discount, and final total must all be
 * correctable). Reuses {@code bagilah}'s own request shapes ({@link CreateReceiptItemRequest},
 * {@link AllocationStrategy}) rather than redefining equivalent DTOs, since confirming a scan is
 * just creating a normal bill through the same public API a manual "New bill" would use — see
 * {@link ReceiptScanService#confirm}.
 */
public record ConfirmReceiptScanRequest(
    @Size(max = 160) String merchant,
    @NotNull LocalDate receiptDate,
    UUID groupId,
    @Valid List<CreateReceiptItemRequest> items,
    @NotNull @DecimalMin(value = "0.00") BigDecimal tax,
    @NotNull AllocationStrategy taxStrategy,
    @NotNull @DecimalMin(value = "0.00") BigDecimal serviceCharge,
    @NotNull AllocationStrategy serviceStrategy,
    @NotNull @DecimalMin(value = "0.00") BigDecimal discount,
    @Size(max = 120) String discountLabel,
    BigDecimal declaredTotal) {}
