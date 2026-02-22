import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';

typedef Delay = Future<void> Function(Duration duration);

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthDataSource dataSource, Delay? delay})
    : _dataSource = dataSource,
      _delay = delay ?? Future<void>.delayed;

  final AuthDataSource _dataSource;
  final Delay _delay;

  @override
  Future<User> login({required String email, required String password}) async {
    // Simulates an external request while keeping domain rules in lower layers.
    await _delay(const Duration(milliseconds: 700));
    return _dataSource.authenticate(email: email, password: password);
  }
}
