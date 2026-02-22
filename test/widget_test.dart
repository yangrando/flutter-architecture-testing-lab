import 'package:flutter/material.dart';
import 'package:flutter_architecture_testing_lab/core/error/failure.dart';
import 'package:flutter_architecture_testing_lab/features/auth/domain/entities/user.dart';
import 'package:flutter_architecture_testing_lab/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_architecture_testing_lab/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_architecture_testing_lab/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({required this.shouldSucceed});

  final bool shouldSucceed;

  @override
  Future<User> login({required String email, required String password}) async {
    if (shouldSucceed) {
      return const User(
        id: 'user-1',
        email: 'test@test.com',
        name: 'Test User',
      );
    }

    throw const AuthFailure('Invalid email or password.');
  }
}

void main() {
  Future<void> pumpLoginScreen(
    WidgetTester tester, {
    required bool shouldSucceed,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(shouldSucceed: shouldSucceed),
          ),
        ],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
  }

  testWidgets('shows success message when credentials are valid', (
    WidgetTester tester,
  ) async {
    await pumpLoginScreen(tester, shouldSucceed: true);

    await tester.enterText(
      find.byKey(const Key('emailField')),
      'test@test.com',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), '123456');
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('successMessage')), findsOneWidget);
    expect(find.byKey(const Key('errorMessage')), findsNothing);
  });

  testWidgets('shows error message when credentials are invalid', (
    WidgetTester tester,
  ) async {
    await pumpLoginScreen(tester, shouldSucceed: false);

    await tester.enterText(
      find.byKey(const Key('emailField')),
      'wrong@test.com',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), 'invalid');
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('errorMessage')), findsOneWidget);
    expect(find.text('Invalid email or password.'), findsOneWidget);
    expect(find.byKey(const Key('successMessage')), findsNothing);
  });
}
