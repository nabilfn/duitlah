package com.duitlah.api.einvoice;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CancelEInvoiceRequest(@NotBlank @Size(max = 300) String reason) {}
