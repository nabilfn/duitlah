import '../../../core/api/api_client.dart';
import '../domain/bagilah_enums.dart';
import '../domain/bill.dart';

/// Wraps `BillController`'s owner/participant endpoints. Every claim/split
/// action here is a thin pass-through to Spring Boot — this repository
/// never computes a split, a total, or a settlement itself; it only shapes
/// requests/responses. See docs/bagilah-engine.md for why that boundary is
/// non-negotiable.
class BagilahRepository {
  BagilahRepository(this._client);

  final ApiClient _client;

  Future<List<Bill>> listBills() async {
    final data = await _client.get('/api/v1/bills') as List;
    return data.map((e) => Bill.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Bill> getBill(String billId) async {
    final data = await _client.get('/api/v1/bills/$billId');
    return Bill.fromJson(data as Map<String, dynamic>);
  }

  Future<Bill> createBill({
    String? groupId,
    String? merchant,
    required String receiptDate,
    String currency = 'MYR',
  }) async {
    final data = await _client.post('/api/v1/bills', data: {
      'groupId': groupId,
      'merchant': merchant,
      'receiptDate': receiptDate,
      'currency': currency,
    });
    return Bill.fromJson(data as Map<String, dynamic>);
  }

  Future<Bill> updateBill(
    String billId, {
    String? merchant,
    String? tax,
    String? taxStrategy,
    String? serviceCharge,
    String? serviceStrategy,
    String? discount,
    String? discountLabel,
    String? declaredTotal,
  }) async {
    final data = await _client.patch('/api/v1/bills/$billId', data: {
      if (merchant != null) 'merchant': merchant,
      if (tax != null) 'tax': tax,
      if (taxStrategy != null) 'taxStrategy': taxStrategy,
      if (serviceCharge != null) 'serviceCharge': serviceCharge,
      if (serviceStrategy != null) 'serviceStrategy': serviceStrategy,
      if (discount != null) 'discount': discount,
      if (discountLabel != null) 'discountLabel': discountLabel,
      if (declaredTotal != null) 'declaredTotal': declaredTotal,
    });
    return Bill.fromJson(data as Map<String, dynamic>);
  }

  Future<List<ReceiptItem>> getItems(String billId) async {
    final data = await _client.get('/api/v1/bills/$billId/items') as List;
    return data.map((e) => ReceiptItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Participant>> getParticipants(String billId) async {
    final data = await _client.get('/api/v1/bills/$billId/participants') as List;
    return data.map((e) => Participant.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Claim>> getClaims(String billId, String itemId) async {
    final data = await _client.get('/api/v1/bills/$billId/items/$itemId/claims') as List;
    return data.map((e) => Claim.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<BillPayment>> getPayments(String billId) async {
    final data = await _client.get('/api/v1/bills/$billId/payments') as List;
    return data.map((e) => BillPayment.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ReceiptItem> addItem(
    String billId, {
    required String name,
    required String quantity,
    required String unitPrice,
    String itemDiscount = '0',
  }) async {
    final data = await _client.post('/api/v1/bills/$billId/items', data: {
      'name': name,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'itemDiscount': itemDiscount,
    });
    return ReceiptItem.fromJson(data as Map<String, dynamic>);
  }

  Future<Participant> addParticipant(String billId, {String? userId, String? displayName}) async {
    final data = await _client.post('/api/v1/bills/$billId/participants', data: {
      if (userId != null) 'userId': userId,
      if (displayName != null) 'displayName': displayName,
    });
    return Participant.fromJson(data as Map<String, dynamic>);
  }

  Future<Claim> addClaim(
    String billId,
    String itemId, {
    required String participantId,
    required ClaimType claimType,
    required String value,
  }) async {
    final data = await _client.post('/api/v1/bills/$billId/items/$itemId/claims', data: {
      'participantId': participantId,
      'claimType': claimType.name,
      'value': value,
    });
    return Claim.fromJson(data as Map<String, dynamic>);
  }

  Future<void> removeClaim(String billId, String itemId, String claimId) =>
      _client.delete('/api/v1/bills/$billId/items/$itemId/claims/$claimId');

  /// Reuses the backend's own `EqualSplitter`-backed convenience endpoint —
  /// never computes an equal split client-side.
  Future<List<Claim>> equalSplit(String billId, String itemId, List<String> participantIds) async {
    final data = await _client.post(
      '/api/v1/bills/$billId/items/$itemId/claims/equal-split',
      data: {'participantIds': participantIds},
    ) as List;
    return data.map((e) => Claim.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Breakdown> getBreakdown(String billId) async {
    final data = await _client.get('/api/v1/bills/$billId/breakdown');
    return Breakdown.fromJson(data as Map<String, dynamic>);
  }

  Future<List<BillBalance>> getBalances(String billId) async {
    final data = await _client.get('/api/v1/bills/$billId/balances') as List;
    return data.map((e) => BillBalance.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Bill> finalizeBill(String billId, {required String idempotencyKey}) async {
    final data = await _client.post(
      '/api/v1/bills/$billId/finalize',
      idempotencyKey: idempotencyKey,
    );
    return Bill.fromJson(data as Map<String, dynamic>);
  }

  Future<String> getInviteToken(String billId) async {
    final data = await _client.post('/api/v1/bills/$billId/invite-token') as Map<String, dynamic>;
    return data['token'] as String? ?? data['inviteToken'] as String;
  }

  Future<void> recordPayment(String billId, {required String participantId, required String amountPaid}) =>
      _client.put('/api/v1/bills/$billId/payments/$participantId', data: {
        'amountPaid': amountPaid,
      });

  Future<void> removePayment(String billId, String participantId) =>
      _client.delete('/api/v1/bills/$billId/payments/$participantId');

  /// Joining via an invite link/QR while already authenticated — resolves
  /// identity from the Bearer token automatically (`joinViaInvite`), same
  /// endpoint a guest hits.
  Future<JoinBillResponse> joinViaInvite({required String token}) async {
    final data = await _client.post('/api/v1/bagilah/join', data: {'token': token});
    return JoinBillResponse.fromJson(data as Map<String, dynamic>);
  }
}
