package com.duitlah.api.accounting;

import com.duitlah.api.common.error.ConflictException;
import com.duitlah.api.common.error.NotFoundException;
import com.duitlah.api.spaces.BusinessPermission;
import com.duitlah.api.spaces.SpaceService;
import java.util.List;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ChartOfAccountsService {

  private final LedgerAccountRepository accounts;
  private final SpaceService spaceService;

  public ChartOfAccountsService(LedgerAccountRepository accounts, SpaceService spaceService) {
    this.accounts = accounts;
    this.spaceService = spaceService;
  }

  @Transactional
  public List<LedgerAccountResponse> seedDefaults(UUID userId, UUID spaceId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BOOKS);
    if (accounts.existsBySpaceId(spaceId)) {
      throw new ConflictException(
          "CHART_OF_ACCOUNTS_ALREADY_SEEDED", "This space already has a chart of accounts.");
    }
    List<LedgerAccount> seeded =
        DefaultChartOfAccounts.ACCOUNTS.stream()
            .map(
                seed ->
                    new LedgerAccount(
                        spaceId,
                        seed.code(),
                        seed.name(),
                        seed.type(),
                        true,
                        seed.cashEquivalent()))
            .toList();
    accounts.saveAll(seeded);
    return seeded.stream().map(LedgerAccountResponse::of).toList();
  }

  @Transactional
  public LedgerAccountResponse create(
      UUID userId, UUID spaceId, CreateLedgerAccountRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BOOKS);
    if (accounts.findBySpaceIdAndCode(spaceId, request.code()).isPresent()) {
      throw new ConflictException(
          "ACCOUNT_CODE_ALREADY_EXISTS", "An account with this code already exists.");
    }
    LedgerAccount account =
        new LedgerAccount(
            spaceId,
            request.code(),
            request.name(),
            request.type(),
            false,
            request.cashEquivalentOrFalse());
    accounts.save(account);
    return LedgerAccountResponse.of(account);
  }

  public List<LedgerAccountResponse> list(UUID userId, UUID spaceId) {
    spaceService.requireMembership(userId, spaceId);
    return accounts.findBySpaceIdOrderByCodeAsc(spaceId).stream()
        .map(LedgerAccountResponse::of)
        .toList();
  }

  public LedgerAccountResponse get(UUID userId, UUID spaceId, UUID accountId) {
    spaceService.requireMembership(userId, spaceId);
    return LedgerAccountResponse.of(requireOwned(spaceId, accountId));
  }

  @Transactional
  public LedgerAccountResponse update(
      UUID userId, UUID spaceId, UUID accountId, CreateLedgerAccountRequest request) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BOOKS);
    LedgerAccount account = requireOwned(spaceId, accountId);
    if (!account.getCode().equals(request.code())
        && accounts.findBySpaceIdAndCode(spaceId, request.code()).isPresent()) {
      throw new ConflictException(
          "ACCOUNT_CODE_ALREADY_EXISTS", "An account with this code already exists.");
    }
    account.setCode(request.code());
    account.setName(request.name());
    account.setType(request.type());
    account.setCashEquivalent(request.cashEquivalentOrFalse());
    accounts.save(account);
    return LedgerAccountResponse.of(account);
  }

  @Transactional
  public void archive(UUID userId, UUID spaceId, UUID accountId) {
    spaceService.requirePermission(userId, spaceId, BusinessPermission.MANAGE_BOOKS);
    LedgerAccount account = requireOwned(spaceId, accountId);
    account.setArchivedAt(java.time.Instant.now());
    accounts.save(account);
  }

  /**
   * Public — {@code bizbanking}/{@code bizexpenses} validate a chart-of-accounts mapping through
   * this before storing it, and {@code AutomaticPostingService} looks accounts up by well-known
   * code through {@link #findByCode}.
   */
  public LedgerAccount requireOwned(UUID spaceId, UUID accountId) {
    return accounts
        .findByIdAndSpaceId(accountId, spaceId)
        .orElseThrow(
            () -> new NotFoundException("LEDGER_ACCOUNT_NOT_FOUND", "Ledger account not found."));
  }

  /** Never throws — a missing/renamed system account means automatic posting quietly skips. */
  public java.util.Optional<LedgerAccount> findByCode(UUID spaceId, String code) {
    return accounts.findBySpaceIdAndCode(spaceId, code);
  }
}
