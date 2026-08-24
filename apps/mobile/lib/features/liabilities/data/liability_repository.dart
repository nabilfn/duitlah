import '../../../core/api/api_client.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/liability.dart';

class LiabilityRepository {
  LiabilityRepository(this._client);

  final ApiClient _client;

  Future<List<Liability>> list() async {
    final data = await _client.get('/api/v1/liabilities') as List;
    return data.map((e) => Liability.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Liability> create({
    required LiabilityType type,
    required String name,
    String? lender,
    required String originalAmount,
    String? interestRatePercent,
    String? instalmentAmount,
    String? nextDueDate,
    String? maturityDate,
  }) async {
    final data = await _client.post('/api/v1/liabilities', data: {
      'type': type.name,
      'name': name,
      if (lender != null) 'lender': lender,
      'originalAmount': originalAmount,
      if (interestRatePercent != null) 'interestRatePercent': interestRatePercent,
      if (instalmentAmount != null) 'instalmentAmount': instalmentAmount,
      if (nextDueDate != null) 'nextDueDate': nextDueDate,
      if (maturityDate != null) 'maturityDate': maturityDate,
    });
    return Liability.fromJson(data as Map<String, dynamic>);
  }

  Future<List<LiabilityPayment>> listPayments(String liabilityId) async {
    final data = await _client.get('/api/v1/liabilities/$liabilityId/payments') as List;
    return data.map((e) => LiabilityPayment.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<LiabilityPayment> recordPayment(
    String liabilityId, {
    required String amount,
    required String principalPortion,
    String? interestPortion,
    required String paidOn,
    String? accountId,
  }) async {
    final data = await _client.post('/api/v1/liabilities/$liabilityId/payments', data: {
      'amount': amount,
      'principalPortion': principalPortion,
      if (interestPortion != null) 'interestPortion': interestPortion,
      'paidOn': paidOn,
      if (accountId != null) 'accountId': accountId,
    });
    return LiabilityPayment.fromJson(data as Map<String, dynamic>);
  }
}

class CreditCardRepository {
  CreditCardRepository(this._client);

  final ApiClient _client;

  Future<CreditCardDetails> setDetails(
    String accountId, {
    required String creditLimit,
    required int statementDay,
    required int paymentDueDay,
    String? minimumPaymentPercent,
  }) async {
    final data = await _client.put('/api/v1/accounts/$accountId/credit-card-details', data: {
      'creditLimit': creditLimit,
      'statementDay': statementDay,
      'paymentDueDay': paymentDueDay,
      if (minimumPaymentPercent != null) 'minimumPaymentPercent': minimumPaymentPercent,
    });
    return CreditCardDetails.fromJson(data as Map<String, dynamic>);
  }

  /// Null if this card hasn't had its limit/statement dates set up yet — a real, expected state
  /// for a freshly-created CREDIT_CARD account, not an error.
  Future<CreditCardDetails?> get(String accountId) async {
    try {
      final data = await _client.get('/api/v1/accounts/$accountId/credit-card-details');
      return CreditCardDetails.fromJson(data as Map<String, dynamic>);
    } on AppException catch (e) {
      if (e.code == 'CREDIT_CARD_DETAILS_NOT_FOUND') return null;
      rethrow;
    }
  }
}
