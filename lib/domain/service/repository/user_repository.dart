import 'dart:convert';

import 'package:picsa/domain/models/models.dart';
import 'package:picsa/domain/service/repository/notification_repository.dart';
import 'package:picsa/main.dart';
import 'package:picsa/utilities/dio_interceptor.dart';
import 'package:picsa/utilities/packages.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

abstract class UserTemplate {
  Future<bool> createUser({required UserModel user});
  Future<UserModel> getUser();
  Future<List<NotificationModel>> getNotifications();
  Future<bool> readNotification({required NotificationModel notification});
  Future<bool> markAsRead();
  Future<bool> showNotificationBadge();
}

class UserRepository extends UserTemplate {
  late final Dio _dio;
  UserRepository() {
    _dio = Dio();
    _dio.interceptors.add(DioInterceptor());
  }

  @override
  Future<bool> createUser({required UserModel user}) async {
    try {
      final token = await NotificationRepository().getNotificationToken();
      final data = {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'url': user.url,
        'token': token,
        'pro': false,
      };
      final response =
          await _dio.post('$API_URL/users/${user.id}', data: jsonEncode(data));
      if (response.statusCode != 201) {
        throw Exception('Error creating user');
      }
      await Purchases.logIn(user.id);
      await Purchases.setEmail(user.email);
      await Purchases.setDisplayName(user.name);
      await Purchases.setPushToken(token);
      await Purchases.collectDeviceIdentifiers();

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      final id = supabase.auth.currentUser!.id;
      final response =
          await _dio.get('$API_URL/users/$id');
      if(response.statusCode != 200) {
        throw Exception('Error getting user');
      }
      final user = UserModel.fromJson(response.data);
      logger.d("user response: ${user.name}");
      return user;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error getting user');
    }
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final id = supabase.auth.currentUser!.id;
      final response =
          await supabase.from('notifications').select().eq('userId', id);
      final notification =
          response.map((e) => NotificationModel.fromJson(e)).toList();
      return notification;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error getting notifications');
    }
  }

  @override
  Future<bool> readNotification(
      {required NotificationModel notification}) async {
    try {
      await supabase.from('notifications').update({
        'id': notification.id,
        'read': true,
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error reading notification');
    }
  }

  @override
  Future<bool> markAsRead() async {
    try {
      final id = supabase.auth.currentUser!.id;
      await supabase.from('notifications').update(
        {
          'read': true,
        },
      ).eq('userId', id);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error reading notification');
    }
  }

  @override
  Future<bool> showNotificationBadge() async {
    try {
      final id = supabase.auth.currentUser!.id;
      final response =
          await supabase.from('notifications').select().eq('userId', id);
      final notification =
          response.map((e) => NotificationModel.fromJson(e)).toList();
      final unread =
          notification.where((element) => element.read == false).toList();
      return unread.isNotEmpty;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error getting notifications');
    }
  }
}
