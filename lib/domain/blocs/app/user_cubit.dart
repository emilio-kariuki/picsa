import 'package:picsa/domain/models/models.dart';

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

  Future<void> getNotifications() async {
    try {
      final notifications = await _userProvider.getNotifications();
      emit(state.copyWith(
          status: UserStatus.success,
          notifications: notifications,
          message: "Notification fetched successfully"));
    } catch (error) {
      emit(state.copyWith(
        status: UserStatus.error,
        message: error.toString().toException(),
      ));
    }
  }

  Future<void> readNotification(
      {required NotificationModel notification}) async {
    try {
      await _userProvider.readNotification(notification: notification);
      final notifications = await _userProvider.getNotifications();
      emit(state.copyWith(
          status: UserStatus.success,
          notifications: notifications,
          message: "Notification updated successfully"));
    } catch (error) {
      emit(state.copyWith(
        status: UserStatus.error,
        message: error.toString().toException(),
      ));
    }
  }

  Future<void> markAsRead() async {
    try {
      emit(state.copyWith(status: UserStatus.loading));
      await _userProvider.markAsRead();
      final notifications = await _userProvider.getNotifications();
      emit(state.copyWith(
          status: UserStatus.success,
          notifications: notifications,
          message: "Notification read successfully"));
    } catch (error) {
      emit(state.copyWith(
        status: UserStatus.error,
        message: error.toString().toException(),
      ));
    }
  }

  Future<void> showNotificationBadge() async {
    try {
      final badge = await _userProvider.showNotificationBadge();
      emit(state.copyWith(
          status: UserStatus.success,
          showBadge: badge,
          message: "Showed notification badge successfully"));

    } catch (error) {
      emit(state.copyWith(
        status: UserStatus.error,
        message: error.toString().toException(),
      ));
    }
  }

  Future<void> loginRevenueCat() async {
    try {
      await Purchases.logIn(supabase.auth.currentUser!.id);
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
  final List<NotificationModel> notifications;
  final bool isPro;
  final bool showBadge;
  final UserStatus status;
  final String message;

  UserState(
      {this.user,
      this.status = UserStatus.initial,
      this.showBadge = false,
      this.message = "",
      this.isPro = false,
      this.notifications = const []});

  UserState copyWith({
    final UserModel? user,
    final List<NotificationModel>? notifications,
    final bool? showBadge,
    final UserStatus? status,
    final bool? isPro,
    final String? message,
  }) {
    return UserState(
        user: user ?? this.user,
        isPro: isPro ?? this.isPro,
        showBadge: showBadge ?? this.showBadge,
        notifications: notifications ?? this.notifications,
        status: status ?? this.status,
        message: message ?? this.message);
  }
}
