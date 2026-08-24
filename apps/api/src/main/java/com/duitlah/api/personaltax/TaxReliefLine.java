package com.duitlah.api.personaltax;

import java.math.BigDecimal;

public record TaxReliefLine(String label, BigDecimal claimedAmount, BigDecimal maxAmount) {}
