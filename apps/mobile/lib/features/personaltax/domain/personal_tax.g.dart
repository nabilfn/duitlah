// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_tax.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonalIncomeRecord _$PersonalIncomeRecordFromJson(
  Map<String, dynamic> json,
) => _PersonalIncomeRecord(
  id: json['id'] as String,
  yearOfAssessment: (json['yearOfAssessment'] as num).toInt(),
  incomeType: $enumDecode(_$IncomeTypeEnumMap, json['incomeType']),
  amount: const AmountConverter().fromJson(json['amount']),
  description: json['description'] as String?,
);

Map<String, dynamic> _$PersonalIncomeRecordToJson(
  _PersonalIncomeRecord instance,
) => <String, dynamic>{
  'id': instance.id,
  'yearOfAssessment': instance.yearOfAssessment,
  'incomeType': _$IncomeTypeEnumMap[instance.incomeType]!,
  'amount': const AmountConverter().toJson(instance.amount),
  'description': instance.description,
};

const _$IncomeTypeEnumMap = {
  IncomeType.EMPLOYMENT: 'EMPLOYMENT',
  IncomeType.BUSINESS: 'BUSINESS',
  IncomeType.RENTAL: 'RENTAL',
  IncomeType.OTHER: 'OTHER',
};

_PcbPayment _$PcbPaymentFromJson(Map<String, dynamic> json) => _PcbPayment(
  id: json['id'] as String,
  yearOfAssessment: (json['yearOfAssessment'] as num).toInt(),
  month: (json['month'] as num).toInt(),
  amount: const AmountConverter().fromJson(json['amount']),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$PcbPaymentToJson(_PcbPayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'yearOfAssessment': instance.yearOfAssessment,
      'month': instance.month,
      'amount': const AmountConverter().toJson(instance.amount),
      'notes': instance.notes,
    };

_ZakatPayment _$ZakatPaymentFromJson(Map<String, dynamic> json) =>
    _ZakatPayment(
      id: json['id'] as String,
      yearOfAssessment: (json['yearOfAssessment'] as num).toInt(),
      amount: const AmountConverter().fromJson(json['amount']),
      paidOn: json['paidOn'] as String,
      receiptId: json['receiptId'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ZakatPaymentToJson(_ZakatPayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'yearOfAssessment': instance.yearOfAssessment,
      'amount': const AmountConverter().toJson(instance.amount),
      'paidOn': instance.paidOn,
      'receiptId': instance.receiptId,
      'notes': instance.notes,
    };

_PersonalTaxDocument _$PersonalTaxDocumentFromJson(Map<String, dynamic> json) =>
    _PersonalTaxDocument(
      id: json['id'] as String,
      yearOfAssessment: (json['yearOfAssessment'] as num).toInt(),
      type: $enumDecode(_$TaxDocumentTypeEnumMap, json['type']),
      receiptId: json['receiptId'] as String?,
      hasFile: json['hasFile'] as bool,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$PersonalTaxDocumentToJson(
  _PersonalTaxDocument instance,
) => <String, dynamic>{
  'id': instance.id,
  'yearOfAssessment': instance.yearOfAssessment,
  'type': _$TaxDocumentTypeEnumMap[instance.type]!,
  'receiptId': instance.receiptId,
  'hasFile': instance.hasFile,
  'notes': instance.notes,
};

const _$TaxDocumentTypeEnumMap = {
  TaxDocumentType.EA: 'EA',
  TaxDocumentType.EC: 'EC',
  TaxDocumentType.PCB_EVIDENCE: 'PCB_EVIDENCE',
  TaxDocumentType.INSURANCE_STATEMENT: 'INSURANCE_STATEMENT',
  TaxDocumentType.EPF_STATEMENT: 'EPF_STATEMENT',
  TaxDocumentType.PRS_STATEMENT: 'PRS_STATEMENT',
  TaxDocumentType.ZAKAT_RECEIPT: 'ZAKAT_RECEIPT',
  TaxDocumentType.MEDICAL_RECEIPT: 'MEDICAL_RECEIPT',
  TaxDocumentType.EDUCATION_RECEIPT: 'EDUCATION_RECEIPT',
  TaxDocumentType.DONATION_EVIDENCE: 'DONATION_EVIDENCE',
  TaxDocumentType.OTHER: 'OTHER',
};

_TaxReliefCandidate _$TaxReliefCandidateFromJson(Map<String, dynamic> json) =>
    _TaxReliefCandidate(
      id: json['id'] as String,
      yearOfAssessment: (json['yearOfAssessment'] as num).toInt(),
      category: $enumDecodeNullable(
        _$PersonalTaxReliefCategoryEnumMap,
        json['category'],
      ),
      sourceReceiptId: json['sourceReceiptId'] as String?,
      suggestedAmount: const AmountConverter().fromJson(
        json['suggestedAmount'],
      ),
      status: $enumDecode(_$TaxReliefCandidateStatusEnumMap, json['status']),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$TaxReliefCandidateToJson(
  _TaxReliefCandidate instance,
) => <String, dynamic>{
  'id': instance.id,
  'yearOfAssessment': instance.yearOfAssessment,
  'category': _$PersonalTaxReliefCategoryEnumMap[instance.category],
  'sourceReceiptId': instance.sourceReceiptId,
  'suggestedAmount': const AmountConverter().toJson(instance.suggestedAmount),
  'status': _$TaxReliefCandidateStatusEnumMap[instance.status]!,
  'notes': instance.notes,
};

const _$PersonalTaxReliefCategoryEnumMap = {
  PersonalTaxReliefCategory.SPOUSE: 'SPOUSE',
  PersonalTaxReliefCategory.CHILD: 'CHILD',
  PersonalTaxReliefCategory.DISABLED_INDIVIDUAL: 'DISABLED_INDIVIDUAL',
  PersonalTaxReliefCategory.PARENTS_MEDICAL_CARE: 'PARENTS_MEDICAL_CARE',
  PersonalTaxReliefCategory.MEDICAL_SERIOUS_ILLNESS: 'MEDICAL_SERIOUS_ILLNESS',
  PersonalTaxReliefCategory.EDUCATION_FEES: 'EDUCATION_FEES',
  PersonalTaxReliefCategory.LIFESTYLE: 'LIFESTYLE',
  PersonalTaxReliefCategory.LIFESTYLE_SPORTS: 'LIFESTYLE_SPORTS',
  PersonalTaxReliefCategory.EPF_LIFE_INSURANCE: 'EPF_LIFE_INSURANCE',
  PersonalTaxReliefCategory.PRS: 'PRS',
  PersonalTaxReliefCategory.SSPN: 'SSPN',
  PersonalTaxReliefCategory.EV_CHARGING: 'EV_CHARGING',
  PersonalTaxReliefCategory.OTHER: 'OTHER',
};

const _$TaxReliefCandidateStatusEnumMap = {
  TaxReliefCandidateStatus.POTENTIALLY_ELIGIBLE: 'POTENTIALLY_ELIGIBLE',
  TaxReliefCandidateStatus.NEEDS_REVIEW: 'NEEDS_REVIEW',
  TaxReliefCandidateStatus.MISSING_EVIDENCE: 'MISSING_EVIDENCE',
  TaxReliefCandidateStatus.CONFIRMED: 'CONFIRMED',
  TaxReliefCandidateStatus.REJECTED: 'REJECTED',
};

_ConfirmedTaxRelief _$ConfirmedTaxReliefFromJson(
  Map<String, dynamic> json,
) => _ConfirmedTaxRelief(
  id: json['id'] as String,
  yearOfAssessment: (json['yearOfAssessment'] as num).toInt(),
  category: $enumDecode(_$PersonalTaxReliefCategoryEnumMap, json['category']),
  confirmedAmount: const AmountConverter().fromJson(json['confirmedAmount']),
);

Map<String, dynamic> _$ConfirmedTaxReliefToJson(
  _ConfirmedTaxRelief instance,
) => <String, dynamic>{
  'id': instance.id,
  'yearOfAssessment': instance.yearOfAssessment,
  'category': _$PersonalTaxReliefCategoryEnumMap[instance.category]!,
  'confirmedAmount': const AmountConverter().toJson(instance.confirmedAmount),
};

_TaxReliefLine _$TaxReliefLineFromJson(Map<String, dynamic> json) =>
    _TaxReliefLine(
      label: json['label'] as String,
      claimedAmount: const AmountConverter().fromJson(json['claimedAmount']),
      maxAmount: const AmountConverter().fromJson(json['maxAmount']),
    );

Map<String, dynamic> _$TaxReliefLineToJson(_TaxReliefLine instance) =>
    <String, dynamic>{
      'label': instance.label,
      'claimedAmount': const AmountConverter().toJson(instance.claimedAmount),
      'maxAmount': const AmountConverter().toJson(instance.maxAmount),
    };

_PersonalTaxCalculation _$PersonalTaxCalculationFromJson(
  Map<String, dynamic> json,
) => _PersonalTaxCalculation(
  yearOfAssessment: (json['yearOfAssessment'] as num).toInt(),
  totalIncome: const AmountConverter().fromJson(json['totalIncome']),
  residentIndividualRelief: const AmountConverter().fromJson(
    json['residentIndividualRelief'],
  ),
  reliefs: (json['reliefs'] as List<dynamic>)
      .map((e) => TaxReliefLine.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalReliefs: const AmountConverter().fromJson(json['totalReliefs']),
  chargeableIncome: const AmountConverter().fromJson(json['chargeableIncome']),
  grossTaxPayable: const AmountConverter().fromJson(json['grossTaxPayable']),
  rebate: const AmountConverter().fromJson(json['rebate']),
  zakatPaid: const AmountConverter().fromJson(json['zakatPaid']),
  zakatRebate: const AmountConverter().fromJson(json['zakatRebate']),
  taxAfterRebatesAndZakat: const AmountConverter().fromJson(
    json['taxAfterRebatesAndZakat'],
  ),
  pcbPaid: const AmountConverter().fromJson(json['pcbPaid']),
  estimatedPayableOrRefund: const AmountConverter().fromJson(
    json['estimatedPayableOrRefund'],
  ),
  disclaimer: json['disclaimer'] as String,
);

Map<String, dynamic> _$PersonalTaxCalculationToJson(
  _PersonalTaxCalculation instance,
) => <String, dynamic>{
  'yearOfAssessment': instance.yearOfAssessment,
  'totalIncome': const AmountConverter().toJson(instance.totalIncome),
  'residentIndividualRelief': const AmountConverter().toJson(
    instance.residentIndividualRelief,
  ),
  'reliefs': instance.reliefs,
  'totalReliefs': const AmountConverter().toJson(instance.totalReliefs),
  'chargeableIncome': const AmountConverter().toJson(instance.chargeableIncome),
  'grossTaxPayable': const AmountConverter().toJson(instance.grossTaxPayable),
  'rebate': const AmountConverter().toJson(instance.rebate),
  'zakatPaid': const AmountConverter().toJson(instance.zakatPaid),
  'zakatRebate': const AmountConverter().toJson(instance.zakatRebate),
  'taxAfterRebatesAndZakat': const AmountConverter().toJson(
    instance.taxAfterRebatesAndZakat,
  ),
  'pcbPaid': const AmountConverter().toJson(instance.pcbPaid),
  'estimatedPayableOrRefund': const AmountConverter().toJson(
    instance.estimatedPayableOrRefund,
  ),
  'disclaimer': instance.disclaimer,
};

_FilingReadinessItem _$FilingReadinessItemFromJson(Map<String, dynamic> json) =>
    _FilingReadinessItem(
      key: json['key'] as String,
      label: json['label'] as String,
      ready: json['ready'] as bool,
      explanation: json['explanation'] as String,
    );

Map<String, dynamic> _$FilingReadinessItemToJson(
  _FilingReadinessItem instance,
) => <String, dynamic>{
  'key': instance.key,
  'label': instance.label,
  'ready': instance.ready,
  'explanation': instance.explanation,
};

_FilingReadiness _$FilingReadinessFromJson(Map<String, dynamic> json) =>
    _FilingReadiness(
      yearOfAssessment: (json['yearOfAssessment'] as num).toInt(),
      readyPercent: const AmountConverter().fromJson(json['readyPercent']),
      items: (json['items'] as List<dynamic>)
          .map((e) => FilingReadinessItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FilingReadinessToJson(_FilingReadiness instance) =>
    <String, dynamic>{
      'yearOfAssessment': instance.yearOfAssessment,
      'readyPercent': const AmountConverter().toJson(instance.readyPercent),
      'items': instance.items,
    };
