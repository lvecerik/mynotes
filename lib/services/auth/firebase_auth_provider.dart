import 'package:firebase_core/firebase_core.dart';
import 'package:my_notes/firebase_options.dart';
import '../../utilities/parse_exc_msg.dart';
import 'auth_exceptions.dart';
import 'auth_provider.dart';
import 'auth_user.dart';
import "package:firebase_auth/firebase_auth.dart";

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
   await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

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
        throw WeakPasswordAuthException();
      } else if (code == "email-already-in-use") {
        throw EmailAlreadyInUsedAuthException();
      } else if (code == "invalid-email") {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
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
  Future<AuthUser> signIn({
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
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> signOut() async {
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
