package com.duitlah.api.liabilities;

import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CreditCardDetailsRepository extends JpaRepository<CreditCardDetails, UUID> {

  Optional<CreditCardDetails> findByAccountId(UUID accountId);
}
