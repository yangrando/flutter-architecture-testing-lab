import '../../../../core/error/failure.dart';
import '../models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> authenticate({
    required String email,
    required String password,
  });
}

class LocalAuthDataSource implements AuthDataSource {
  const LocalAuthDataSource();

  @override
  Future<UserModel> authenticate({
    required String email,
    required String password,
  }) async {
    if (email == 'test@test.com' && password == '123456') {
      return const UserModel(
        id: 'user-1',
        email: 'test@test.com',
        name: 'Test User',
      );
    }

    throw const AuthFailure('Invalid email or password.');
  }
}
