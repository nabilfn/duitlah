package com.duitlah.api.settlements;

import java.math.BigDecimal;
import org.springframework.stereotype.Service;

@Service
public class ManualPaymentHandoffLinkService implements PaymentHandoffService {

  @Override
  public PaymentHandoffLink buildHandoffLink(BigDecimal amount, String payeeDisplayName) {
    String instructions =
        "Transfer RM"
            + amount.toPlainString()
            + " to "
            + payeeDisplayName
            + " via DuitNow, bank transfer, or your usual e-wallet, then mark it as paid here.";
    return new PaymentHandoffLink("MANUAL", instructions, null);
  }
}
