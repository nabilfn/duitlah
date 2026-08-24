package com.duitlah.api.crossspace;

import java.math.BigDecimal;
import java.util.UUID;

public record BusinessOwnershipLine(UUID spaceId, String spaceName, BigDecimal equityValue) {}
