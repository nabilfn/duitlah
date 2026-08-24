package com.duitlah.api.settlements;

import java.math.BigDecimal;

/**
 * Duitlah never holds funds (product spec section 19): it determines obligations, an external
 * payment happens some other way, and Duitlah just records that it happened. This interface is the
 * "some other way" — abstracted so a real integration (DuitNow, DuitNow QR, a bank deep link, a
 * specific e-wallet handoff) can be swapped in later without anything above this layer changing.
 * {@link ManualPaymentHandoffLinkService} is the only implementation today: it has no real
 * payment-provider credentials to integrate against, so it just returns instructions for a manual
 * transfer — an honest placeholder, not a simulated integration.
 */
public interface PaymentHandoffService {

  PaymentHandoffLink buildHandoffLink(BigDecimal amount, String payeeDisplayName);
}
