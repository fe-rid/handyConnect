import 'package:equatable/equatable.dart';

import 'enums.dart';

class ServiceRequest extends Equatable {
  final String id;
  final String customerId;
  final String handymanId;
  final String issueDescription;
  final DateTime preferredTime;
  final RequestStatus status;

  const ServiceRequest({
    required this.id,
    required this.customerId,
    required this.handymanId,
    required this.issueDescription,
    required this.preferredTime,
    required this.status,
  });

  ServiceRequest copyWith({
    RequestStatus? status,
  }) => ServiceRequest(
    id: id,
    customerId: customerId,
    handymanId: handymanId,
    issueDescription: issueDescription,
    preferredTime: preferredTime,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [id, customerId, handymanId, issueDescription, preferredTime, status];
}
