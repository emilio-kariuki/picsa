

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationRepository {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;
  NotificationRepository() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    channel = const AndroidNotificationChannel(
      'low_importance_channel',
      'Low Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('picsa');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
      ),
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: false,
    );
  }

  Future<String> getNotificationToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      debugPrint('The firebase messaging token is: $token');
      return token!;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Error getting firebase messaging token');
    }
  }

  Future<void> showLowNotification({
    required String message,
    required String title,
  }) async {
    return flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "2",
          'Low normal Notifications',
          channelDescription: "This is the notifications normal channel",
          importance: Importance.high,
          priority: Priority.high,
          showWhen: false,
        ),
      ),
    );
  }


  Future initializeFirebaseMessaging() async {
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: false,
        badge: true,
        sound: false,
      );
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint("Message received: ${message.notification!.body}");

        showLowNotification(
          message: message.data['message'] ?? message.contentAvailable.toString(),
          title: message.data['title'] ?? message.notification!.title!,
        );
      });
    } catch (e) {
      debugPrint(e.toString());
      throw Exception("Error initializing firebase messaging");
    }
  }


  // Future<String> _downloadAndSaveFile(String url, String fileName) async {
  //   final Directory directory = await getApplicationDocumentsDirectory();
  //   final String filePath = '${directory.path}/$fileName';
  //   final response = await Dio()
  //       .get(url, options: Options(responseType: ResponseType.bytes));
  //   final File file = File(filePath);
  //   await file.writeAsBytes(response.data);
  //   return filePath;
  // }
}
