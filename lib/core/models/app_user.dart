import 'package:equatable/equatable.dart';

import 'enums.dart';

class AppUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? location;
  final String? profilePhotoUrl;
  final UserType userType;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.phone,
    this.location,
    this.profilePhotoUrl,
  });

  AppUser copyWith({
    String? name,
    String? phone,
    String? location,
    String? profilePhotoUrl,
    UserType? userType,
  }) => AppUser(
    id: id,
    name: name ?? this.name,
    email: email,
    userType: userType ?? this.userType,
    phone: phone ?? this.phone,
    location: location ?? this.location,
    profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
  );

  @override
  List<Object?> get props => [id, name, email, userType, phone, location, profilePhotoUrl];
}
