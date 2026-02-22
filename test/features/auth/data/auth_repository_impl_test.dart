import 'package:flutter_architecture_testing_lab/core/error/failure.dart';
import 'package:flutter_architecture_testing_lab/features/auth/data/datasources/auth_data_source.dart';
import 'package:flutter_architecture_testing_lab/features/auth/data/models/user_model.dart';
import 'package:flutter_architecture_testing_lab/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {}

void main() {
  late MockAuthDataSource mockAuthDataSource;
  late AuthRepositoryImpl repository;

  const validEmail = 'test@test.com';
  const validPassword = '123456';

  setUp(() {
    mockAuthDataSource = MockAuthDataSource();
    repository = AuthRepositoryImpl(
      dataSource: mockAuthDataSource,
      delay: (_) async {},
    );
  });

  test('returns User when datasource authenticates successfully', () async {
    const expectedUser = UserModel(
      id: 'user-1',
      email: validEmail,
      name: 'Test User',
    );

    when(
      () => mockAuthDataSource.authenticate(
        email: validEmail,
        password: validPassword,
      ),
    ).thenAnswer((_) async => expectedUser);

    final result = await repository.login(
      email: validEmail,
      password: validPassword,
    );

    expect(result, expectedUser);
    verify(
      () => mockAuthDataSource.authenticate(
        email: validEmail,
        password: validPassword,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockAuthDataSource);
  });

  test('rethrows AuthFailure when datasource rejects credentials', () async {
    when(
      () => mockAuthDataSource.authenticate(
        email: validEmail,
        password: validPassword,
      ),
    ).thenThrow(const AuthFailure('Invalid email or password.'));

    await expectLater(
      () => repository.login(email: validEmail, password: validPassword),
      throwsA(isA<AuthFailure>()),
    );

    verify(
      () => mockAuthDataSource.authenticate(
        email: validEmail,
        password: validPassword,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockAuthDataSource);
  });
}
