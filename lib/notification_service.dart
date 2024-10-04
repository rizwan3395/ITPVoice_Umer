import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:itp_voice/routes.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Android notification channel details
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),  // For iOS devices
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _onDidReceiveBackgroundNotificationResponse,
    );

    // Android: Create notification channel for high-priority notifications
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Request permission for iOS notifications
    await FirebaseMessaging.instance.requestPermission();

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        createanddisplaynotification(message);
      }
    });

    try {
      final token = await FirebaseMessaging.instance.getToken();
      print("Firebase Token: $token");
    } catch (e) {
      print("Error getting Firebase token: $e");
    }
  }

  static Future<void> _onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final payload = notificationResponse.payload;
    if (payload != null) {
      _handleNotificationPayload(payload);
    } else {
      print("Notification payload is null.");
    }
  }

  static Future<void> _onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) async {
    final payload = notificationResponse.payload;
    if (payload != null) {
      _handleNotificationPayload(payload);
    } else {
      print("Notification payload is null.");
    }
  }

  static void _handleNotificationPayload(String payload) {
    try {
      final notificationData = jsonDecode(payload) as Map<String, dynamic>;

      if (notificationData.containsKey("message_thread_id")) {
        final messageThreadId = notificationData["message_thread_id"];
        final toPhoneNumber = notificationData["to_phone_number"];

        // Navigate to chat screen
        Get.toNamed(
          Routes.CHAT_SCREEN_ROUTE,
          arguments: [messageThreadId, toPhoneNumber, null],
        );
      } else {
        print("Payload does not contain 'message_thread_id'.");
      }
    } catch (e) {
      print("Error parsing notification payload: $e");
    }
  }

  // Display notification
  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      final androidNotification = message.notification?.android;

      if (notification != null && androidNotification != null) {
        // Prepare Android notification details
        const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        );

        // Notification details
        const NotificationDetails platformDetails = NotificationDetails(
          android: androidDetails,
        );

        // Display notification
        await _notificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          platformDetails,
          payload: jsonEncode(message.data), // Pass data as payload
        );
      }
    } catch (e) {
      print("Error displaying notification: $e");
    }
  }
}



// https://api.itpscorp.com/portal/crm/auth/reset-pw?username=abc@gmail.com&from=voice360