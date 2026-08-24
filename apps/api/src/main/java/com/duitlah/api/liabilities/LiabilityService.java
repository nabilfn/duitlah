package com.duitlah.api.liabilities;

import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.SpaceService;
import com.duitlah.api.transactions.CreateTransactionRequest;
import com.duitlah.api.transactions.TransactionResponse;
import com.duitlah.api.transactions.TransactionService;
import com.duitlah.api.transactions.TransactionType;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class LiabilityService {

  private final LiabilityRepository liabilities;
  private final LiabilityPaymentRepository payments;
  private final SpaceService spaceService;
  private final TransactionService transactionService;

  public LiabilityService(
      LiabilityRepository liabilities,
      LiabilityPaymentRepository payments,
      SpaceService spaceService,
      TransactionService transactionService) {
    this.liabilities = liabilities;
    this.payments = payments;
    this.spaceService = spaceService;
    this.transactionService = transactionService;
  }

  @Transactional
  public LiabilityResponse create(UUID userId, CreateLiabilityRequest request) {
    Liability liability =
        new Liability(
            userId,
            spaceService.personalSpaceIdFor(userId),
            request.type(),
            request.name().trim(),
            request.lender(),
            request.originalAmount(),
            request.interestRatePercent(),
            request.instalmentAmount(),
            request.nextDueDate(),
            request.maturityDate());
    liabilities.save(liability);
    return LiabilityResponse.of(liability, liability.getOriginalAmount());
  }

  public List<LiabilityResponse> list(UUID userId) {
    return liabilities.findByUserIdOrderByCreatedAtDesc(userId).stream()
        .map(l -> LiabilityResponse.of(l, outstandingPrincipal(l)))
        .toList();
  }

  public LiabilityResponse get(UUID userId, UUID liabilityId) {
    Liability liability = requireOwned(userId, liabilityId);
    return LiabilityResponse.of(liability, outstandingPrincipal(liability));
  }

  public List<LiabilityPaymentResponse> listPayments(UUID userId, UUID liabilityId) {
    requireOwned(userId, liabilityId);
    return payments.findByLiabilityIdOrderByPaidOnDesc(liabilityId).stream()
        .map(LiabilityPaymentResponse::from)
        .toList();
  }

  @Transactional
  public LiabilityPaymentResponse recordPayment(
      UUID userId, UUID liabilityId, RecordLiabilityPaymentRequest request) {
    Liability liability = requireOwned(userId, liabilityId);
    if (liability.getStatus() != LiabilityStatus.ACTIVE) {
      throw new ApiException(
          HttpStatus.CONFLICT, "LIABILITY_NOT_ACTIVE", "This liability is no longer active.");
    }

    UUID linkedTransactionId = null;
    if (request.accountId() != null) {
      TransactionResponse transaction =
          transactionService.create(
              userId,
              new CreateTransactionRequest(
                  request.accountId(),
                  TransactionType.EXPENSE,
                  null,
                  request.amount(),
                  liability.getLender(),
                  liability.getName() + " payment",
                  null,
                  request.paidOn(),
                  null,
                  null,
                  null));
      linkedTransactionId = transaction.id();
    }

    LiabilityPayment payment =
        new LiabilityPayment(
            liabilityId,
            request.amount(),
            request.principalPortion(),
            request.interestPortionOrZero(),
            request.paidOn(),
            linkedTransactionId);
    payments.save(payment);

    if (outstandingPrincipal(liability).compareTo(BigDecimal.ZERO) <= 0) {
      liability.setStatus(LiabilityStatus.PAID_OFF);
      liabilities.save(liability);
    }

    return LiabilityPaymentResponse.from(payment);
  }

  public BigDecimal outstandingPrincipal(Liability liability) {
    return liability
        .getOriginalAmount()
        .subtract(payments.sumPrincipalPortionByLiabilityId(liability.getId()))
        .max(BigDecimal.ZERO);
  }

  private Liability requireOwned(UUID userId, UUID liabilityId) {
    return liabilities
        .findByIdAndUserId(liabilityId, userId)
        .orElseThrow(() -> new NotFoundException("LIABILITY_NOT_FOUND", "Liability not found."));
  }
}
