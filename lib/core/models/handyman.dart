import 'package:equatable/equatable.dart';

import 'enums.dart';

class HandymanProfile extends Equatable {
  final String id;
  final String userId;
  final String fullName;
  final ServiceCategory serviceType;
  final String? description;
  final int? experienceYears;
  final String? location;
  final Map<String, String>? contactLinks; // e.g., {'whatsapp': '...', 'telegram': '...'}
  final String? photoUrl;

  const HandymanProfile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.serviceType,
    this.description,
    this.experienceYears,
    this.location,
    this.contactLinks,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [id, userId, fullName, serviceType, description, experienceYears, location, contactLinks, photoUrl];
}
