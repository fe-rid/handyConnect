import '../../core/models/app_user.dart';
import '../../core/models/enums.dart';

abstract class AuthRepository {
  AppUser? get currentUser;
  Stream<AppUser?> authState();

  Future<AppUser> signInWithEmail({required String email, required String password});
  Future<AppUser> signUpWithEmail({required String name, required String email, required String password, required UserType userType});
  Future<void> signOut();
}
