import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:picsa/domain/models/user_model.dart';
import 'package:picsa/domain/service/repository/auth_repository.dart';
import 'package:picsa/domain/service/repository/user_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());
      final response = await AuthRepository().signInWithGoogle();
      emit(AuthSuccess(user: response));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> createUser({required UserModel user}) async {
    await UserRepository().createUser(user: user);
  }
}
