package com.duitlah.api.bagilah;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.time.LocalDate;
import java.util.UUID;

public record CreateBillRequest(
    @Size(max = 160) String merchant, @NotNull LocalDate receiptDate, UUID groupId) {}
