import 'package:picsa/domain/models/models.dart';
import 'package:picsa/domain/models/user_model.dart';
import 'package:picsa/domain/service/service_locator.dart';
import 'package:picsa/utilities/packages.dart';

import '../../service/providers/user_provider.dart';

class UserCubit extends Cubit<UserState> {
  final _userProvider = service<UserProvider>();
  UserCubit() : super(UserState());

  Future<void> getUser() async {
    try {
      final user = await _userProvider.getUser();
      emit(state.copyWith(
          status: UserStatus.success,
          user: user,
          message: "User fetched successfully"));
    } catch (error) {
      emit(state.copyWith(
        status: UserStatus.error,
        message: error.toString().toException(),
      ));
    }
  }

  Future<void> createUser({required UserModel user}) async {
    try {
      await _userProvider.createUser(user: user);
      emit(state.copyWith(
          status: UserStatus.success, message: "User created successfully"));
    } catch (error) {
      emit(state.copyWith(
        status: UserStatus.error,
        message: error.toString().toException(),
      ));
    }
  }
}

//* UserState

enum UserStatus { initial, loading, success, error }

class UserState {
  final UserModel? user;
  final UserStatus status;
  final String message;

  UserState({this.user, this.status = UserStatus.initial, this.message = ""});

  UserState copyWith({
    final UserModel? user,
    final UserStatus? status,
    final String? message,
  }) {
    return UserState(
        user: user ?? this.user,
        status: status ?? this.status,
        message: message ?? this.message);
  }
}
