import '../../../core/api/api_client.dart';
import '../domain/contacts.dart';

/// Talks to the identically-shaped `/customers` and `/suppliers` endpoints —
/// kept as one repository since the request/response wire shape and the
/// verbs are identical, only the base segment and the resulting model type
/// differ.
class ContactsRepository {
  ContactsRepository(this._client);

  final ApiClient _client;

  Map<String, dynamic> _requestBody({
    required String name,
    String? contactPerson,
    String? phone,
    String? email,
    String? billingAddress,
    String? registrationNumber,
    String? tin,
    String? sstNumber,
    int? paymentTermsDays,
    String? notes,
  }) =>
      {
        'name': name,
        if (contactPerson != null) 'contactPerson': contactPerson,
        if (phone != null) 'phone': phone,
        if (email != null) 'email': email,
        if (billingAddress != null) 'billingAddress': billingAddress,
        if (registrationNumber != null) 'registrationNumber': registrationNumber,
        if (tin != null) 'tin': tin,
        if (sstNumber != null) 'sstNumber': sstNumber,
        if (paymentTermsDays != null) 'paymentTermsDays': paymentTermsDays,
        if (notes != null) 'notes': notes,
      };

  Future<List<Customer>> listCustomers(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/customers') as List;
    return data.map((e) => Customer.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Customer> getCustomer(String spaceId, String id) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/customers/$id');
    return Customer.fromJson(data as Map<String, dynamic>);
  }

  Future<Customer> createCustomer(
    String spaceId, {
    required String name,
    String? contactPerson,
    String? phone,
    String? email,
    String? billingAddress,
    String? registrationNumber,
    String? tin,
    String? sstNumber,
    int? paymentTermsDays,
    String? notes,
  }) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/customers',
      data: _requestBody(
        name: name,
        contactPerson: contactPerson,
        phone: phone,
        email: email,
        billingAddress: billingAddress,
        registrationNumber: registrationNumber,
        tin: tin,
        sstNumber: sstNumber,
        paymentTermsDays: paymentTermsDays,
        notes: notes,
      ),
    );
    return Customer.fromJson(data as Map<String, dynamic>);
  }

  Future<Customer> updateCustomer(
    String spaceId,
    String id, {
    required String name,
    String? contactPerson,
    String? phone,
    String? email,
    String? billingAddress,
    String? registrationNumber,
    String? tin,
    String? sstNumber,
    int? paymentTermsDays,
    String? notes,
  }) async {
    final data = await _client.put(
      '/api/v1/spaces/$spaceId/customers/$id',
      data: _requestBody(
        name: name,
        contactPerson: contactPerson,
        phone: phone,
        email: email,
        billingAddress: billingAddress,
        registrationNumber: registrationNumber,
        tin: tin,
        sstNumber: sstNumber,
        paymentTermsDays: paymentTermsDays,
        notes: notes,
      ),
    );
    return Customer.fromJson(data as Map<String, dynamic>);
  }

  Future<void> archiveCustomer(String spaceId, String id) => _client.delete('/api/v1/spaces/$spaceId/customers/$id');

  Future<List<Supplier>> listSuppliers(String spaceId) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/suppliers') as List;
    return data.map((e) => Supplier.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Supplier> getSupplier(String spaceId, String id) async {
    final data = await _client.get('/api/v1/spaces/$spaceId/suppliers/$id');
    return Supplier.fromJson(data as Map<String, dynamic>);
  }

  Future<Supplier> createSupplier(
    String spaceId, {
    required String name,
    String? contactPerson,
    String? phone,
    String? email,
    String? billingAddress,
    String? registrationNumber,
    String? tin,
    String? sstNumber,
    int? paymentTermsDays,
    String? notes,
  }) async {
    final data = await _client.post(
      '/api/v1/spaces/$spaceId/suppliers',
      data: _requestBody(
        name: name,
        contactPerson: contactPerson,
        phone: phone,
        email: email,
        billingAddress: billingAddress,
        registrationNumber: registrationNumber,
        tin: tin,
        sstNumber: sstNumber,
        paymentTermsDays: paymentTermsDays,
        notes: notes,
      ),
    );
    return Supplier.fromJson(data as Map<String, dynamic>);
  }

  Future<Supplier> updateSupplier(
    String spaceId,
    String id, {
    required String name,
    String? contactPerson,
    String? phone,
    String? email,
    String? billingAddress,
    String? registrationNumber,
    String? tin,
    String? sstNumber,
    int? paymentTermsDays,
    String? notes,
  }) async {
    final data = await _client.put(
      '/api/v1/spaces/$spaceId/suppliers/$id',
      data: _requestBody(
        name: name,
        contactPerson: contactPerson,
        phone: phone,
        email: email,
        billingAddress: billingAddress,
        registrationNumber: registrationNumber,
        tin: tin,
        sstNumber: sstNumber,
        paymentTermsDays: paymentTermsDays,
        notes: notes,
      ),
    );
    return Supplier.fromJson(data as Map<String, dynamic>);
  }

  Future<void> archiveSupplier(String spaceId, String id) => _client.delete('/api/v1/spaces/$spaceId/suppliers/$id');
}
