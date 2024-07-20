import 'package:picsa/domain/models/notification_model.dart';
import 'package:picsa/domain/models/user_model.dart';
import 'package:picsa/domain/service/repository/user_repository.dart';

class UserProvider extends UserTemplate {
  final UserRepository _userRepository;
  UserProvider({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<bool> createUser({required UserModel user}) {
    return _userRepository.createUser(user: user);
  }

  @override
  Future<UserModel> getUser() {
    return _userRepository.getUser();
  }

  @override
  Future<List<NotificationModel>> getNotifications() {
    return _userRepository.getNotifications();
  }

  @override
  Future<bool> readNotification({required NotificationModel notification}) {
    return _userRepository.readNotification(notification: notification);
  }

  @override
  Future<bool> markAsRead() {
    return _userRepository.markAsRead();
  }

  @override
  Future<bool> showNotificationBadge() {
    return _userRepository.showNotificationBadge();
  }
}
