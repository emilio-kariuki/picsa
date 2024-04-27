import 'package:picsa/domain/models/user_model.dart';
import 'package:picsa/domain/service/repository/auth_repository.dart';
import 'package:picsa/domain/service/repository/user_repository.dart';
import 'package:picsa/utilities/packages.dart';

class AuthCubit extends Cubit<AuthenticationState> {
  AuthCubit() : super(AuthenticationState());

  Future<void> signInWithGoogle() async {
    try {
      emit(state.copyWith(
        status: AuthStatus.loading,
        message: "Signing in with Google...",
      ));
      final response = await AuthRepository().signInWithGoogle();
      emit(state.copyWith(
        user: response,
        status: AuthStatus.success,
        message: "Signed in with Google",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        message: e.toString().toException(),
      ));
    }
  }

  Future<void> createUser() async {
    await UserRepository().createUser(user: state.user!);
  }

  Future<void> signOut() async {
    try {
      emit(state.copyWith(
          status: AuthStatus.loading, message: "Signing out..."));
      await AuthRepository().signOut();
      emit(state.copyWith(status: AuthStatus.success, message: "Signed out"));
    } catch (error) {
      emit(state.copyWith(
          status: AuthStatus.error, message: error.toString().toException()));
    }
  }
}

enum AuthStatus { initial, loading, success, error }

class AuthenticationState {
  final UserModel? user;
  final AuthStatus status;
  final String message;
  AuthenticationState({
    this.user,
    this.status = AuthStatus.initial,
    this.message = "",
  });

  AuthenticationState copyWith({
    UserModel? user,
    AuthStatus status = AuthStatus.initial,
    String message = "",
  }) {
    return AuthenticationState(
      user: user ?? this.user,
      status: status,
      message: message,
    );
  }
}
