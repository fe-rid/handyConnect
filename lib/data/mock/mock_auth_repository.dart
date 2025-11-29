import 'dart:async';

import '../../core/models/app_user.dart';
import '../../core/models/enums.dart';
import '../repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  AppUser? _user;
  final _controller = StreamController<AppUser?>.broadcast();

  @override
  AppUser? get currentUser => _user;

  @override
  Stream<AppUser?> authState() => _controller.stream;

  @override
  Future<AppUser> signInWithEmail({required String email, required String password}) async {
    // Just return a mock customer
    _user = AppUser(id: 'u1', name: 'Customer One', email: email, userType: UserType.customer);
    _controller.add(_user);
    return _user!;
  }

  @override
  Future<AppUser> signUpWithEmail({required String name, required String email, required String password, required UserType userType}) async {
    _user = AppUser(id: 'u${DateTime.now().millisecondsSinceEpoch}', name: name, email: email, userType: userType);
    _controller.add(_user);
    return _user!;
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(null);
  }
}
