import 'package:my_notes/services/auth/auth_exceptions.dart';
import 'package:my_notes/services/auth/auth_provider.dart';
import 'package:my_notes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test("Should not be initialized at start", () {
      expect(provider.isInitialized, false);
    });
    test("Cannot log out if not initialized", () {
      expect(
        provider.signOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    test("Should be able to initialize", () async {
      await provider.initialize();
      expect(provider._isInitialized, true);
    });

    test("User should be null after init.", () {
      expect(provider.currentUser, null);
    });

    test(
      "Should be able init. in less then 2sec",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test("create user should delegate to signIn", () async {
      final badMailUser = provider.createUser(
        email: "foo@bar.com",
        password: "anypassword",
      );
      expect(
          badMailUser, throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser =
          provider.createUser(email: "maul@test.com", password: "foobar");
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: "test@mail.com",
        password: "password",
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test("Logged in user should be able to get verified", () async {
      await provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("should be able to sign in and out", () async {
      await provider.signOut();
      await provider.signIn(email: "test@mail.com", password: "password");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  AuthUser? _user;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return signIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    Future.delayed(const Duration(seconds: 2));
    _isInitialized = true;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      email: "mail@mail.com",
      isEmailVerified: true,
      id: "my_id",
    );
    _user = newUser;
  }

  @override
  Future<AuthUser> signIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "foo@bar.com") throw UserNotFoundAuthException();
    if (password == "foobar") throw WrongPasswordAuthException();
    const user =
        AuthUser(email: "mail@mail.com", isEmailVerified: false, id: "my_id");
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> signOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }
}
