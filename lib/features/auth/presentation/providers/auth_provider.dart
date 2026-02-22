import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../data/datasources/auth_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_user.dart';

class AuthState {
  const AuthState({this.isLoading = false, this.user, this.errorMessage});

  final bool isLoading;
  final User? user;
  final String? errorMessage;

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? errorMessage,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({required LoginUser loginUser})
    : _loginUser = loginUser,
      super(const AuthState());

  final LoginUser _loginUser;

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true, clearUser: true);

    try {
      final user = await _loginUser(email: email, password: password);
      state = state.copyWith(isLoading: false, user: user, clearError: true);
    } on Failure catch (failure) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
        clearUser: true,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error. Please try again.',
        clearUser: true,
      );
    }
  }
}

// Dependency graph is wired here so each layer remains replaceable in tests.
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return const LocalAuthDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(dataSource: ref.watch(authDataSourceProvider));
});

final loginUserProvider = Provider<LoginUser>((ref) {
  return LoginUser(ref.watch(authRepositoryProvider));
});

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier(loginUser: ref.watch(loginUserProvider));
});
