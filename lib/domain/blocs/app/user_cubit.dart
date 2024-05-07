import 'package:picsa/domain/models/models.dart';
import 'package:picsa/domain/models/user_model.dart';
import 'package:picsa/domain/service/service_locator.dart';
import 'package:picsa/utilities/packages.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../service/providers/user_provider.dart';

class UserCubit extends Cubit<UserState> {
  final _userProvider = service<UserProvider>();
  UserCubit() : super(UserState());

  Future<void> getUser() async {
    try {
      final user = await _userProvider.getUser();
      debugPrint("UserCubit: getUser ${user.pro}");
      emit(state.copyWith(
          status: UserStatus.success,
          user: user,
          isPro: user.pro,
          message: "User fetched successfully"));
    } catch (error) {
      emit(state.copyWith(
        status: UserStatus.error,
        message: error.toString().toException(),
      ));
    }
  }

  Future<void> loginRevenueCat() async {
    try {
      debugPrint("UserCubit: loginRevenueCat ${supabase.auth.currentUser!.id}");
      LogInResult result = await Purchases.logIn(supabase.auth.currentUser!.id);
      debugPrint("UserCubit: loginRevenueCat ${result.customerInfo}");
      emit(state.copyWith(
          status: UserStatus.success,
          message: "Revenue logged in successfully"));
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
  final bool isPro;
  final UserStatus status;
  final String message;

  UserState({this.user, this.status = UserStatus.initial, this.message = "", this.isPro = false});

  UserState copyWith({
    final UserModel? user,
    final UserStatus? status,
    final bool ?isPro,
    final String? message,
  }) {
    return UserState(
        user: user ?? this.user,
        isPro: isPro ?? this.isPro,
        status: status ?? this.status,
        message: message ?? this.message);
  }
}
