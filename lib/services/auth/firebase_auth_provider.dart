import '../../utilities/parse_exc_msg.dart';
import 'auth_exceptions.dart';
import 'auth_provider.dart';
import 'auth_user.dart';
import "package:firebase_auth/firebase_auth.dart";

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthExceptions();
      }
    } on FirebaseAuthException catch (e) {
      final code = parseFirebaseAuthExceptionMessage(input: e.message);
      if (code == "weak-password") {
        throw WeakPasswordAuthExcetion();
      } else if (code == "email-already-in-use") {
        throw EmailAlreadyInUsedAuthExcetion();
      } else if (code == "invalid-email") {
        throw InvalidEmailAuthExcetion();
      } else {
        throw GenericAuthExcetion();
      }
    } catch (_) {
      throw GenericAuthExcetion();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthExceptions();
      }
    } on FirebaseAuthException catch (e) {
      final code = parseFirebaseAuthExceptionMessage(input: e.message);
      if (code == "user-not-found") {
        throw UserNotFoundAuthException();
      } else if (code == "wrong-password") {
        throw WrongPasswordAuthExcetion();
      } else {
        throw GenericAuthExcetion();
      }
    } catch (_) {
      throw GenericAuthExcetion();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthExceptions();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthExceptions();
    }
  }
}
