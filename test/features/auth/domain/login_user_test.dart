import 'package:flutter_architecture_testing_lab/core/error/failure.dart';
import 'package:flutter_architecture_testing_lab/features/auth/domain/entities/user.dart';
import 'package:flutter_architecture_testing_lab/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_architecture_testing_lab/features/auth/domain/usecases/login_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginUser useCase;

  const validEmail = 'test@test.com';
  const validPassword = '123456';
  const expectedUser = User(id: 'user-1', email: validEmail, name: 'Test User');

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = LoginUser(mockAuthRepository);
  });

  test('returns user when repository login succeeds', () async {
    when(
      () =>
          mockAuthRepository.login(email: validEmail, password: validPassword),
    ).thenAnswer((_) async => expectedUser);

    final result = await useCase(email: validEmail, password: validPassword);

    expect(result, expectedUser);
    verify(
      () =>
          mockAuthRepository.login(email: validEmail, password: validPassword),
    ).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('throws AuthFailure when repository login fails', () async {
    when(
      () =>
          mockAuthRepository.login(email: validEmail, password: validPassword),
    ).thenThrow(const AuthFailure('Invalid email or password.'));

    await expectLater(
      () => useCase(email: validEmail, password: validPassword),
      throwsA(isA<AuthFailure>()),
    );

    verify(
      () =>
          mockAuthRepository.login(email: validEmail, password: validPassword),
    ).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
