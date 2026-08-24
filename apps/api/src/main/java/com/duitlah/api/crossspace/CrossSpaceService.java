package com.duitlah.api.crossspace;

import com.duitlah.api.accounting.AutomaticPostingService;
import com.duitlah.api.accounting.ChartOfAccountsService;
import com.duitlah.api.bizbanking.BusinessAccount;
import com.duitlah.api.bizbanking.BusinessAccountService;
import com.duitlah.api.bizbanking.CreateEntryRequest;
import com.duitlah.api.bizbanking.EntryDirection;
import com.duitlah.api.common.error.ApiException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import com.duitlah.api.transactions.Transaction;
import com.duitlah.api.transactions.TransactionRepository;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/** The four linked actions (spec sections 58-60). See package-info. */
@Service
public class CrossSpaceService {

  private final CrossSpaceLinkRepository links;
  private final TransactionRepository transactions;
  private final BusinessAccountService businessAccountService;
  private final ChartOfAccountsService chartOfAccountsService;
  private final AutomaticPostingService automaticPostingService;
  private final SpaceService spaceService;

  public CrossSpaceService(
      CrossSpaceLinkRepository links,
      TransactionRepository transactions,
      BusinessAccountService businessAccountService,
      ChartOfAccountsService chartOfAccountsService,
      AutomaticPostingService automaticPostingService,
      SpaceService spaceService) {
    this.links = links;
    this.transactions = transactions;
    this.businessAccountService = businessAccountService;
    this.chartOfAccountsService = chartOfAccountsService;
    this.automaticPostingService = automaticPostingService;
    this.spaceService = spaceService;
  }

  /**
   * Section 58: a personal-paid business expense. No business cash actually moved (the owner paid
   * personally), so unlike the other three actions the journal posting isn't best-effort — the
   * Chart of Accounts must genuinely have a "Due to Owner" account, or there would be nothing to
   * link at all.
   */
  @Transactional
  public CrossSpaceLinkResponse recordBusinessAdvance(
      UUID userId, UUID businessSpaceId, RecordBusinessAdvanceRequest request) {
    spaceService.requirePermission(userId, businessSpaceId, BusinessPermission.MANAGE_BOOKS);
    Transaction personalTransaction =
        requireOwnTransaction(userId, request.personalTransactionId());
    chartOfAccountsService.requireOwned(businessSpaceId, request.expenseChartOfAccountsId());

    CrossSpaceLink link =
        new CrossSpaceLink(
            userId,
            businessSpaceId,
            CrossSpaceLinkType.BUSINESS_ADVANCE,
            personalTransaction.getId(),
            null,
            request.amount(),
            request.description(),
            userId);
    links.save(link);

    Optional<UUID> journalEntryId =
        automaticPostingService.postBusinessAdvance(
            businessSpaceId,
            userId,
            link.getId(),
            request.occurredOn(),
            request.amount(),
            description(request, "Business advance"),
            request.expenseChartOfAccountsId());
    if (journalEntryId.isEmpty()) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "DUE_TO_OWNER_ACCOUNT_MISSING",
          "Seed or restore the \"Due to Owner\" account in Chart of Accounts before recording a business advance.");
    }
    link.setBusinessJournalEntryId(journalEntryId.get());
    links.save(link);
    return CrossSpaceLinkResponse.of(link);
  }

  /**
   * Section 58: never classified as income on the Personal side or a new business expense on the
   * Business side.
   */
  @Transactional
  public CrossSpaceLinkResponse recordReimbursement(
      UUID userId, UUID businessSpaceId, RecordReimbursementRequest request) {
    spaceService.requirePermission(userId, businessSpaceId, BusinessPermission.MANAGE_BANKING);
    Transaction personalTransaction =
        requireOwnTransaction(userId, request.personalTransactionId());
    BusinessAccount account =
        businessAccountService.requireOwned(businessSpaceId, request.businessAccountId());
    if (request.relatedLinkId() != null) {
      requireLinkOfType(
          businessSpaceId, request.relatedLinkId(), CrossSpaceLinkType.BUSINESS_ADVANCE);
    }

    businessAccountService.addEntry(
        userId,
        businessSpaceId,
        request.businessAccountId(),
        new CreateEntryRequest(
            EntryDirection.OUT,
            request.amount(),
            request.occurredOn(),
            description(request, "Reimbursement")));

    CrossSpaceLink link =
        new CrossSpaceLink(
            userId,
            businessSpaceId,
            CrossSpaceLinkType.REIMBURSEMENT,
            personalTransaction.getId(),
            request.relatedLinkId(),
            request.amount(),
            request.description(),
            userId);
    links.save(link);

    automaticPostingService
        .postReimbursement(
            businessSpaceId,
            userId,
            link.getId(),
            request.occurredOn(),
            request.amount(),
            description(request, "Reimbursement"),
            account.getChartOfAccountsId())
        .ifPresent(
            journalEntryId -> {
              link.setBusinessJournalEntryId(journalEntryId);
              links.save(link);
            });
    return CrossSpaceLinkResponse.of(link);
  }

  /** Section 59: not Business Revenue. */
  @Transactional
  public CrossSpaceLinkResponse recordOwnerContribution(
      UUID userId, UUID businessSpaceId, RecordOwnerContributionRequest request) {
    spaceService.requirePermission(userId, businessSpaceId, BusinessPermission.MANAGE_BANKING);
    Transaction personalTransaction =
        requireOwnTransaction(userId, request.personalTransactionId());
    BusinessAccount account =
        businessAccountService.requireOwned(businessSpaceId, request.businessAccountId());

    businessAccountService.addEntry(
        userId,
        businessSpaceId,
        request.businessAccountId(),
        new CreateEntryRequest(
            EntryDirection.IN,
            request.amount(),
            request.occurredOn(),
            description(request, "Owner contribution")));

    CrossSpaceLink link =
        new CrossSpaceLink(
            userId,
            businessSpaceId,
            CrossSpaceLinkType.OWNER_CONTRIBUTION,
            personalTransaction.getId(),
            null,
            request.amount(),
            request.description(),
            userId);
    links.save(link);

    automaticPostingService
        .postOwnerContribution(
            businessSpaceId,
            userId,
            link.getId(),
            request.occurredOn(),
            request.amount(),
            description(request, "Owner contribution"),
            account.getChartOfAccountsId())
        .ifPresent(
            journalEntryId -> {
              link.setBusinessJournalEntryId(journalEntryId);
              links.save(link);
            });
    return CrossSpaceLinkResponse.of(link);
  }

  /** Section 60: not a normal business expense. */
  @Transactional
  public CrossSpaceLinkResponse recordOwnerDrawing(
      UUID userId, UUID businessSpaceId, RecordOwnerDrawingRequest request) {
    spaceService.requirePermission(userId, businessSpaceId, BusinessPermission.MANAGE_BANKING);
    Transaction personalTransaction =
        requireOwnTransaction(userId, request.personalTransactionId());
    BusinessAccount account =
        businessAccountService.requireOwned(businessSpaceId, request.businessAccountId());

    businessAccountService.addEntry(
        userId,
        businessSpaceId,
        request.businessAccountId(),
        new CreateEntryRequest(
            EntryDirection.OUT,
            request.amount(),
            request.occurredOn(),
            description(request, "Owner drawing")));

    CrossSpaceLink link =
        new CrossSpaceLink(
            userId,
            businessSpaceId,
            CrossSpaceLinkType.OWNER_DRAWING,
            personalTransaction.getId(),
            null,
            request.amount(),
            request.description(),
            userId);
    links.save(link);

    automaticPostingService
        .postOwnerDrawing(
            businessSpaceId,
            userId,
            link.getId(),
            request.occurredOn(),
            request.amount(),
            description(request, "Owner drawing"),
            account.getChartOfAccountsId())
        .ifPresent(
            journalEntryId -> {
              link.setBusinessJournalEntryId(journalEntryId);
              links.save(link);
            });
    return CrossSpaceLinkResponse.of(link);
  }

  public List<CrossSpaceLinkResponse> listForBusiness(UUID userId, UUID businessSpaceId) {
    spaceService.requireMembership(userId, businessSpaceId);
    return links.findByBusinessSpaceIdOrderByCreatedAtDesc(businessSpaceId).stream()
        .map(CrossSpaceLinkResponse::of)
        .toList();
  }

  public List<CrossSpaceLinkResponse> listForPersonal(UUID userId) {
    return links.findByPersonalUserIdOrderByCreatedAtDesc(userId).stream()
        .map(CrossSpaceLinkResponse::of)
        .toList();
  }

  private Transaction requireOwnTransaction(UUID userId, UUID transactionId) {
    return transactions
        .findByIdAndUserId(transactionId, userId)
        .orElseThrow(
            () ->
                new NotFoundException("TRANSACTION_NOT_FOUND", "Personal transaction not found."));
  }

  private void requireLinkOfType(UUID businessSpaceId, UUID linkId, CrossSpaceLinkType type) {
    CrossSpaceLink related =
        links
            .findByIdAndBusinessSpaceId(linkId, businessSpaceId)
            .orElseThrow(
                () ->
                    new NotFoundException("CROSS_SPACE_LINK_NOT_FOUND", "Related link not found."));
    if (related.getLinkType() != type) {
      throw new ApiException(
          HttpStatus.CONFLICT,
          "CROSS_SPACE_LINK_TYPE_MISMATCH",
          "The related link isn't a " + type + ".");
    }
  }

  private String description(RecordBusinessAdvanceRequest request, String fallback) {
    return request.description() != null && !request.description().isBlank()
        ? request.description()
        : fallback;
  }

  private String description(RecordReimbursementRequest request, String fallback) {
    return request.description() != null && !request.description().isBlank()
        ? request.description()
        : fallback;
  }

  private String description(RecordOwnerContributionRequest request, String fallback) {
    return request.description() != null && !request.description().isBlank()
        ? request.description()
        : fallback;
  }

  private String description(RecordOwnerDrawingRequest request, String fallback) {
    return request.description() != null && !request.description().isBlank()
        ? request.description()
        : fallback;
  }
}
