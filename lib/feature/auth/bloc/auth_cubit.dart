import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/app_user.dart';
import '../../../core/models/enums.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthState {
  final AppUser? user;
  final bool loading;
  final String? error;
  const AuthState({this.user, this.loading = false, this.error});

  AuthState copyWith({AppUser? user, bool? loading, String? error}) =>
      AuthState(user: user ?? this.user, loading: loading ?? this.loading, error: error);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AuthCubit(this.authRepository) : super(const AuthState()) {
    authRepository.authState().listen((u) => emit(state.copyWith(user: u, loading: false, error: null)));
  }

  Future<void> signIn(String email, String password) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final u = await authRepository.signInWithEmail(email: email, password: password);
      emit(state.copyWith(user: u, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> signUp(String name, String email, String password, UserType type) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final u = await authRepository.signUpWithEmail(name: name, email: email, password: password, userType: type);
      emit(state.copyWith(user: u, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> signOut() async {
    await authRepository.signOut();
    emit(const AuthState());
  }
}
