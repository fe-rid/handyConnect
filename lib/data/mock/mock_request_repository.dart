import '../../core/models/enums.dart';
import '../../core/models/service_request.dart';
import '../repositories/request_repository.dart';
import 'mock_data.dart';

class MockRequestRepository implements RequestRepository {
  final List<ServiceRequest> _items = [];

  @override
  Future<ServiceRequest> createRequest({required String customerId, required String handymanId, required String description, required DateTime preferredTime}) async {
    final req = ServiceRequest(
      id: MockData.newId('r'),
      customerId: customerId,
      handymanId: handymanId,
      issueDescription: description,
      preferredTime: preferredTime,
      status: RequestStatus.pending,
    );
    _items.add(req);
    return req;
  }

  @override
  Future<List<ServiceRequest>> getCustomerRequests(String customerId) async {
    return _items.where((e) => e.customerId == customerId).toList();
  }

  @override
  Future<List<ServiceRequest>> getHandymanRequests(String handymanId) async {
    return _items.where((e) => e.handymanId == handymanId).toList();
  }

  @override
  Future<ServiceRequest?> getById(String id) async {
    try {
      return _items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ServiceRequest> updateStatus(String requestId, RequestStatus status) async {
    final idx = _items.indexWhere((e) => e.id == requestId);
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(status: status);
      return _items[idx];
    }
    throw StateError('Request not found');
  }
}
