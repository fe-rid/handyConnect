import '../../core/models/service_request.dart';
import '../../core/models/enums.dart';

abstract class RequestRepository {
  Future<ServiceRequest> createRequest({
    required String customerId,
    required String handymanId,
    required String description,
    required DateTime preferredTime,
  });

  Future<List<ServiceRequest>> getCustomerRequests(String customerId);
  Future<List<ServiceRequest>> getHandymanRequests(String handymanId);
  Future<ServiceRequest?> getById(String id);
  Future<ServiceRequest> updateStatus(String requestId, RequestStatus status);
}
