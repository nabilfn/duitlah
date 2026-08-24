import '../../../core/api/api_client.dart';
import '../domain/personal_bill.dart';

class PersonalBillRepository {
  PersonalBillRepository(this._client);

  final ApiClient _client;

  Future<List<PersonalBill>> list({BillStatus? status}) async {
    final data = await _client.get(
      '/api/v1/personal-bills',
      query: {if (status != null) 'status': status.name},
    ) as List;
    return data.map((e) => PersonalBill.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PersonalBill> create({
    required String name,
    String? provider,
    required String dueDate,
    required String expectedAmount,
    BillRecurrence recurrence = BillRecurrence.NONE,
  }) async {
    final data = await _client.post('/api/v1/personal-bills', data: {
      'name': name,
      if (provider != null) 'provider': provider,
      'dueDate': dueDate,
      'expectedAmount': expectedAmount,
      'recurrence': recurrence.name,
    });
    return PersonalBill.fromJson(data as Map<String, dynamic>);
  }

  Future<PersonalBill> markPaid(
    String billId, {
    required String accountId,
    String? categoryId,
    required String amount,
    required String paidOn,
  }) async {
    final data = await _client.post('/api/v1/personal-bills/$billId/mark-paid', data: {
      'accountId': accountId,
      if (categoryId != null) 'categoryId': categoryId,
      'amount': amount,
      'paidOn': paidOn,
    });
    return PersonalBill.fromJson(data as Map<String, dynamic>);
  }

  Future<PersonalBill> skip(String billId) async {
    final data = await _client.post('/api/v1/personal-bills/$billId/skip');
    return PersonalBill.fromJson(data as Map<String, dynamic>);
  }

  /// Links an already-uploaded Receipt Vault receipt to this bill —
  /// verified server-side to actually belong to the caller before linking,
  /// so a client-supplied [receiptId] is never trusted at face value.
  Future<PersonalBill> attachReceipt(String billId, String receiptId) async {
    final data = await _client.post('/api/v1/personal-bills/$billId/receipt?receiptId=$receiptId');
    return PersonalBill.fromJson(data as Map<String, dynamic>);
  }
}
