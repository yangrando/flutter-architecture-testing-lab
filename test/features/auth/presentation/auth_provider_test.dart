import 'package:flutter_architecture_testing_lab/core/error/failure.dart';
import 'package:flutter_architecture_testing_lab/features/auth/domain/entities/user.dart';
import 'package:flutter_architecture_testing_lab/features/auth/domain/usecases/login_user.dart';
import 'package:flutter_architecture_testing_lab/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUser extends Mock implements LoginUser {}

void main() {
  late MockLoginUser mockLoginUser;
  late AuthNotifier notifier;

  const validEmail = 'test@test.com';
  const validPassword = '123456';

  setUp(() {
    mockLoginUser = MockLoginUser();
    notifier = AuthNotifier(loginUser: mockLoginUser);
  });

  test('emits success state when login succeeds', () async {
    const user = User(id: 'user-1', email: validEmail, name: 'Test User');
    when(
      () => mockLoginUser.call(email: validEmail, password: validPassword),
    ).thenAnswer((_) async => user);

    await notifier.login(email: validEmail, password: validPassword);

    expect(notifier.state.isLoading, isFalse);
    expect(notifier.state.user, user);
    expect(notifier.state.errorMessage, isNull);
    verify(
      () => mockLoginUser.call(email: validEmail, password: validPassword),
    ).called(1);
    verifyNoMoreInteractions(mockLoginUser);
  });

  test('emits error state when login fails', () async {
    when(
      () => mockLoginUser.call(email: validEmail, password: validPassword),
    ).thenThrow(const AuthFailure('Invalid email or password.'));

    await notifier.login(email: validEmail, password: validPassword);

    expect(notifier.state.isLoading, isFalse);
    expect(notifier.state.user, isNull);
    expect(notifier.state.errorMessage, 'Invalid email or password.');
    verify(
      () => mockLoginUser.call(email: validEmail, password: validPassword),
    ).called(1);
    verifyNoMoreInteractions(mockLoginUser);
  });
}
