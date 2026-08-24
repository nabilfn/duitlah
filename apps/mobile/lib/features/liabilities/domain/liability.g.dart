// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Liability _$LiabilityFromJson(Map<String, dynamic> json) => _Liability(
  id: json['id'] as String,
  type: $enumDecode(_$LiabilityTypeEnumMap, json['type']),
  name: json['name'] as String,
  lender: json['lender'] as String?,
  originalAmount: const AmountConverter().fromJson(json['originalAmount']),
  outstandingPrincipal: const AmountConverter().fromJson(
    json['outstandingPrincipal'],
  ),
  interestRatePercent: const NullableAmountConverter().fromJson(
    json['interestRatePercent'],
  ),
  instalmentAmount: const NullableAmountConverter().fromJson(
    json['instalmentAmount'],
  ),
  nextDueDate: json['nextDueDate'] as String?,
  maturityDate: json['maturityDate'] as String?,
  status: $enumDecode(_$LiabilityStatusEnumMap, json['status']),
);

Map<String, dynamic> _$LiabilityToJson(_Liability instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$LiabilityTypeEnumMap[instance.type]!,
      'name': instance.name,
      'lender': instance.lender,
      'originalAmount': const AmountConverter().toJson(instance.originalAmount),
      'outstandingPrincipal': const AmountConverter().toJson(
        instance.outstandingPrincipal,
      ),
      'interestRatePercent': const NullableAmountConverter().toJson(
        instance.interestRatePercent,
      ),
      'instalmentAmount': const NullableAmountConverter().toJson(
        instance.instalmentAmount,
      ),
      'nextDueDate': instance.nextDueDate,
      'maturityDate': instance.maturityDate,
      'status': _$LiabilityStatusEnumMap[instance.status]!,
    };

const _$LiabilityTypeEnumMap = {
  LiabilityType.PERSONAL_LOAN: 'PERSONAL_LOAN',
  LiabilityType.CAR_LOAN: 'CAR_LOAN',
  LiabilityType.HOUSING_LOAN: 'HOUSING_LOAN',
  LiabilityType.EDUCATION_LOAN: 'EDUCATION_LOAN',
  LiabilityType.PTPTN: 'PTPTN',
  LiabilityType.BNPL: 'BNPL',
  LiabilityType.OTHER: 'OTHER',
};

const _$LiabilityStatusEnumMap = {
  LiabilityStatus.ACTIVE: 'ACTIVE',
  LiabilityStatus.PAID_OFF: 'PAID_OFF',
  LiabilityStatus.DEFAULTED: 'DEFAULTED',
};

_LiabilityPayment _$LiabilityPaymentFromJson(
  Map<String, dynamic> json,
) => _LiabilityPayment(
  id: json['id'] as String,
  amount: const AmountConverter().fromJson(json['amount']),
  principalPortion: const AmountConverter().fromJson(json['principalPortion']),
  interestPortion: const AmountConverter().fromJson(json['interestPortion']),
  paidOn: json['paidOn'] as String,
  linkedTransactionId: json['linkedTransactionId'] as String?,
);

Map<String, dynamic> _$LiabilityPaymentToJson(
  _LiabilityPayment instance,
) => <String, dynamic>{
  'id': instance.id,
  'amount': const AmountConverter().toJson(instance.amount),
  'principalPortion': const AmountConverter().toJson(instance.principalPortion),
  'interestPortion': const AmountConverter().toJson(instance.interestPortion),
  'paidOn': instance.paidOn,
  'linkedTransactionId': instance.linkedTransactionId,
};

_CreditCardDetails _$CreditCardDetailsFromJson(
  Map<String, dynamic> json,
) => _CreditCardDetails(
  accountId: json['accountId'] as String,
  creditLimit: const AmountConverter().fromJson(json['creditLimit']),
  statementDay: (json['statementDay'] as num).toInt(),
  paymentDueDay: (json['paymentDueDay'] as num).toInt(),
  minimumPaymentPercent: const AmountConverter().fromJson(
    json['minimumPaymentPercent'],
  ),
  currentOutstanding: const AmountConverter().fromJson(
    json['currentOutstanding'],
  ),
  availableCredit: const AmountConverter().fromJson(json['availableCredit']),
  utilization: const AmountConverter().fromJson(json['utilization']),
  statementBalance: const AmountConverter().fromJson(json['statementBalance']),
  minimumPaymentDue: const AmountConverter().fromJson(
    json['minimumPaymentDue'],
  ),
);

Map<String, dynamic> _$CreditCardDetailsToJson(
  _CreditCardDetails instance,
) => <String, dynamic>{
  'accountId': instance.accountId,
  'creditLimit': const AmountConverter().toJson(instance.creditLimit),
  'statementDay': instance.statementDay,
  'paymentDueDay': instance.paymentDueDay,
  'minimumPaymentPercent': const AmountConverter().toJson(
    instance.minimumPaymentPercent,
  ),
  'currentOutstanding': const AmountConverter().toJson(
    instance.currentOutstanding,
  ),
  'availableCredit': const AmountConverter().toJson(instance.availableCredit),
  'utilization': const AmountConverter().toJson(instance.utilization),
  'statementBalance': const AmountConverter().toJson(instance.statementBalance),
  'minimumPaymentDue': const AmountConverter().toJson(
    instance.minimumPaymentDue,
  ),
};
