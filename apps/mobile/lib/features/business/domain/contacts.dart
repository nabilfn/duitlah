// ignore_for_file: constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contacts.freezed.dart';
part 'contacts.g.dart';

/// Shared by both [Customer] and [Supplier] — the backend keeps them as
/// separate entities/tables (separate `/customers` and `/suppliers`
/// endpoints, separate archival state) even though the response shape is
/// identical, so the two are kept as distinct model classes here too rather
/// than one shared class with a `kind` flag.
enum ContactStatus { ACTIVE, ARCHIVED }

@freezed
abstract class Customer with _$Customer {
  const factory Customer({
    required String id,
    required String name,
    String? contactPerson,
    String? phone,
    String? email,
    String? billingAddress,
    String? registrationNumber,
    String? tin,
    String? sstNumber,
    required int paymentTermsDays,
    String? notes,
    required ContactStatus status,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
}

@freezed
abstract class Supplier with _$Supplier {
  const factory Supplier({
    required String id,
    required String name,
    String? contactPerson,
    String? phone,
    String? email,
    String? billingAddress,
    String? registrationNumber,
    String? tin,
    String? sstNumber,
    required int paymentTermsDays,
    String? notes,
    required ContactStatus status,
  }) = _Supplier;

  factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);
}
