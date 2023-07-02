import 'package:my_notes/services/auth/firebase_auth_provider.dart';
import 'auth_provider.dart';
import 'auth_user.dart';

//má zmysel pri viacerých auth provideroch
class AuthService implements AuthProvider {  
  final AuthProvider provider;
  AuthService(this.provider); 

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) =>
      provider.signIn(
        email: email,
        password: password,
      );

  @override
  Future<void> signOut() => provider.signOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
