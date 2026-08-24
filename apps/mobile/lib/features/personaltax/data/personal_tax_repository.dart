import '../../../core/api/api_client.dart';
import '../domain/personal_tax.dart';

class PersonalTaxRepository {
  PersonalTaxRepository(this._client);

  final ApiClient _client;

  Future<PersonalTaxCalculation> calculate(int yearOfAssessment) async {
    final data = await _client.get('/api/v1/personal-tax/calculation', query: {'yearOfAssessment': yearOfAssessment});
    return PersonalTaxCalculation.fromJson(data as Map<String, dynamic>);
  }

  Future<FilingReadiness> filingReadiness(int yearOfAssessment) async {
    final data = await _client.get(
      '/api/v1/personal-tax/filing-readiness',
      query: {'yearOfAssessment': yearOfAssessment},
    );
    return FilingReadiness.fromJson(data as Map<String, dynamic>);
  }

  Future<List<int>> downloadPreparationSummary(int yearOfAssessment) =>
      _client.downloadBytes('/api/v1/personal-tax/preparation-summary', query: {'yearOfAssessment': yearOfAssessment});

  Future<List<PersonalIncomeRecord>> listIncome(int yearOfAssessment) async {
    final data = await _client.get('/api/v1/personal-tax/income', query: {'yearOfAssessment': yearOfAssessment}) as List;
    return data.map((e) => PersonalIncomeRecord.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PersonalIncomeRecord> addIncome({
    required int yearOfAssessment,
    required IncomeType incomeType,
    required String amount,
    String? description,
  }) async {
    final data = await _client.post('/api/v1/personal-tax/income', data: {
      'yearOfAssessment': yearOfAssessment,
      'incomeType': incomeType.name,
      'amount': amount,
      if (description != null) 'description': description,
    });
    return PersonalIncomeRecord.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteIncome(String recordId) => _client.delete('/api/v1/personal-tax/income/$recordId');

  Future<List<PcbPayment>> listPcb(int yearOfAssessment) async {
    final data = await _client.get('/api/v1/personal-tax/pcb', query: {'yearOfAssessment': yearOfAssessment}) as List;
    return data.map((e) => PcbPayment.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PcbPayment> recordPcb({required int yearOfAssessment, required int month, required String amount}) async {
    final data = await _client.post('/api/v1/personal-tax/pcb', data: {
      'yearOfAssessment': yearOfAssessment,
      'month': month,
      'amount': amount,
    });
    return PcbPayment.fromJson(data as Map<String, dynamic>);
  }

  Future<List<ZakatPayment>> listZakat(int yearOfAssessment) async {
    final data = await _client.get('/api/v1/personal-tax/zakat', query: {'yearOfAssessment': yearOfAssessment}) as List;
    return data.map((e) => ZakatPayment.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ZakatPayment> recordZakat({required int yearOfAssessment, required String amount, required String paidOn}) async {
    final data = await _client.post('/api/v1/personal-tax/zakat', data: {
      'yearOfAssessment': yearOfAssessment,
      'amount': amount,
      'paidOn': paidOn,
    });
    return ZakatPayment.fromJson(data as Map<String, dynamic>);
  }

  Future<List<PersonalTaxDocument>> listDocuments(int yearOfAssessment) async {
    final data =
        await _client.get('/api/v1/personal-tax/documents', query: {'yearOfAssessment': yearOfAssessment}) as List;
    return data.map((e) => PersonalTaxDocument.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PersonalTaxDocument> uploadDocument({
    required String filePath,
    required int yearOfAssessment,
    required TaxDocumentType type,
  }) async {
    final data = await _client.uploadFiles(
      '/api/v1/personal-tax/documents/upload',
      fieldName: 'file',
      filePaths: [filePath],
      query: {'yearOfAssessment': yearOfAssessment, 'type': type.name},
    );
    return PersonalTaxDocument.fromJson(data as Map<String, dynamic>);
  }

  Future<List<TaxReliefCandidate>> listReliefCandidates(int yearOfAssessment) async {
    final data = await _client.get(
      '/api/v1/personal-tax/relief-candidates',
      query: {'yearOfAssessment': yearOfAssessment},
    ) as List;
    return data.map((e) => TaxReliefCandidate.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<TaxReliefCandidate> createReliefCandidate({
    required int yearOfAssessment,
    required String suggestedAmount,
    PersonalTaxReliefCategory? category,
  }) async {
    final data = await _client.post('/api/v1/personal-tax/relief-candidates', data: {
      'yearOfAssessment': yearOfAssessment,
      'suggestedAmount': suggestedAmount,
      if (category != null) 'category': category.name,
    });
    return TaxReliefCandidate.fromJson(data as Map<String, dynamic>);
  }

  Future<ConfirmedTaxRelief> confirmReliefCandidate(
    String candidateId, {
    required PersonalTaxReliefCategory category,
    required String amount,
  }) async {
    final data = await _client.post('/api/v1/personal-tax/relief-candidates/$candidateId/confirm', data: {
      'category': category.name,
      'amount': amount,
    });
    return ConfirmedTaxRelief.fromJson(data as Map<String, dynamic>);
  }

  Future<TaxReliefCandidate> rejectReliefCandidate(String candidateId) async {
    final data = await _client.post('/api/v1/personal-tax/relief-candidates/$candidateId/reject');
    return TaxReliefCandidate.fromJson(data as Map<String, dynamic>);
  }

  Future<List<ConfirmedTaxRelief>> listConfirmedReliefs(int yearOfAssessment) async {
    final data = await _client.get(
      '/api/v1/personal-tax/confirmed-reliefs',
      query: {'yearOfAssessment': yearOfAssessment},
    ) as List;
    return data.map((e) => ConfirmedTaxRelief.fromJson(e as Map<String, dynamic>)).toList();
  }
}
