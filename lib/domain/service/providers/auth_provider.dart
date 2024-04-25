import 'package:picsa/domain/models/user_model.dart';
import 'package:picsa/domain/service/repository/auth_repository.dart';

class AuthProvider extends AuthTemplate {
  final AuthRepository _authRepository;
  AuthProvider({required AuthRepository authRepository})
      : _authRepository = authRepository;
  @override
  Future<bool> isSignedIn() {
    return _authRepository.isSignedIn();
  }

  @override
  Future<UserModel> signInWithGoogle() {
    return _authRepository.signInWithGoogle();
  }

  @override
  Future<void> signOut() {
    return _authRepository.signOut();
  }
}
