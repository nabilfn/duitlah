import '../../../core/api/api_client.dart';
import '../domain/cross_space.dart';

/// Phase 11 — Cross-Space Accounting. Links an already-existing *personal*
/// transaction to a business-side action without ever merging the two
/// ledgers — the personal transaction itself is never modified by any of
/// the four actions below, only referenced by
/// [CrossSpaceLinkResponse.personalTransactionId]. `business-advance`
/// requires the server-enforced `MANAGE_BOOKS` permission; the other three
/// require `MANAGE_BANKING` — never guessed client-side, only ever a real
/// 403 `INSUFFICIENT_PERMISSION` surfaced from the server. A 404
/// `TRANSACTION_NOT_FOUND` means the transaction either doesn't exist or
/// doesn't belong to the caller — both look identical to the UI.
class CrossSpaceRepository {
  CrossSpaceRepository(this._client);

  final ApiClient _client;

  // ---- The four link actions -----------------------------------------------

  /// The owner personally paid for something the business needed. Posts a
  /// real business journal entry: debit [expenseChartOfAccountsId], credit
  /// "Due to Owner" (a liability — the business now owes the owner).
  /// Throws 409 `DUE_TO_OWNER_ACCOUNT_MISSING` if the business's Chart of
  /// Accounts has no "Due to Owner" account seeded.
  Future<CrossSpaceLinkResponse> createBusinessAdvance(
    String spaceId, {
    required String personalTransactionId,
    required String expenseChartOfAccountsId,
    required String amount,
    required String occurredOn,
    String? description,
  }) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/crossspace/business-advance',
      data: {
        'personalTransactionId': personalTransactionId,
        'expenseChartOfAccountsId': expenseChartOfAccountsId,
        'amount': amount,
        'occurredOn': occurredOn,
        if (description != null) 'description': description,
      },
    );
    return CrossSpaceLinkResponse.fromJson(data as Map<String, dynamic>);
  }

  /// The business pays the owner back — typically settling a prior
  /// [createBusinessAdvance]. Debits "Due to Owner" (clearing the
  /// liability), credits [businessAccountId] (real cash leaves the
  /// business). [relatedLinkId] optionally names the original
  /// business-advance link this settles — throws 409
  /// `CROSS_SPACE_LINK_TYPE_MISMATCH` if it doesn't point at one.
  Future<CrossSpaceLinkResponse> createReimbursement(
    String spaceId, {
    required String personalTransactionId,
    required String businessAccountId,
    String? relatedLinkId,
    required String amount,
    required String occurredOn,
    String? description,
  }) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/crossspace/reimbursement',
      data: {
        'personalTransactionId': personalTransactionId,
        'businessAccountId': businessAccountId,
        if (relatedLinkId != null) 'relatedLinkId': relatedLinkId,
        'amount': amount,
        'occurredOn': occurredOn,
        if (description != null) 'description': description,
      },
    );
    return CrossSpaceLinkResponse.fromJson(data as Map<String, dynamic>);
  }

  /// The owner puts their own money into the business (e.g. to capitalize
  /// it). Debits [businessAccountId], credits "Owner's Capital" — never
  /// revenue.
  Future<CrossSpaceLinkResponse> createOwnerContribution(
    String spaceId, {
    required String personalTransactionId,
    required String businessAccountId,
    required String amount,
    required String occurredOn,
    String? description,
  }) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/crossspace/owner-contribution',
      data: {
        'personalTransactionId': personalTransactionId,
        'businessAccountId': businessAccountId,
        'amount': amount,
        'occurredOn': occurredOn,
        if (description != null) 'description': description,
      },
    );
    return CrossSpaceLinkResponse.fromJson(data as Map<String, dynamic>);
  }

  /// The owner takes money out of the business for personal use — not a
  /// salary, not a normal expense. Debits "Owner's Drawings", credits
  /// [businessAccountId].
  Future<CrossSpaceLinkResponse> createOwnerDrawing(
    String spaceId, {
    required String personalTransactionId,
    required String businessAccountId,
    required String amount,
    required String occurredOn,
    String? description,
  }) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/crossspace/owner-drawing',
      data: {
        'personalTransactionId': personalTransactionId,
        'businessAccountId': businessAccountId,
        'amount': amount,
        'occurredOn': occurredOn,
        if (description != null) 'description': description,
      },
    );
    return CrossSpaceLinkResponse.fromJson(data as Map<String, dynamic>);
  }

  // ---- Listing ----------------------------------------------------------

  /// Every link recorded for this business, newest first.
  Future<List<CrossSpaceLinkResponse>> listSpaceLinks(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/crossspace/links') as List;
    return data.map((e) => CrossSpaceLinkResponse.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Every link the current user has personally created, across every
  /// business they belong to — no spaceId in the path, unlike
  /// [listSpaceLinks]. Not currently surfaced on a screen of its own, but
  /// kept here so the repository's API surface matches the backend
  /// contract in full.
  Future<List<CrossSpaceLinkResponse>> listMyLinks() async {
    final data = await _client.get('/api/v1/crossspace/links') as List;
    return data.map((e) => CrossSpaceLinkResponse.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ---- Combined net worth -------------------------------------------------

  /// Read-only and informational — the current user's own Personal net
  /// worth plus each business they own's computed equity value, summed
  /// into an estimate. No spaceId: this is inherently the caller's own
  /// aggregate view across every space at once.
  Future<CombinedNetWorth> getCombinedNetWorth() async {
    final data = await _client.get('/api/v1/crossspace/net-worth');
    return CombinedNetWorth.fromJson(data as Map<String, dynamic>);
  }
}
