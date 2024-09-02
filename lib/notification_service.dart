import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:itp_voice/routes.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      // iOS: IOSInitializationSettings(),  // Uncomment if targeting iOS
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: _onDidReceiveBackgroundNotificationResponse,
    );

    try {
      final token = await FirebaseMessaging.instance.getToken();
      print("Firebase Token: $token");
    } catch (e) {
      print("Error getting Firebase token: $e");
    }
  }

  static Future<void> _onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) async {
    final payload = notificationResponse.payload;
    if (payload != null) {
      try {
        final notificationData = jsonDecode(payload) as Map<String, dynamic>;
        
        if (notificationData.containsKey("message_thread_id")) {
          final messageThreadId = notificationData["message_thread_id"];
          final toPhoneNumber = notificationData["to_phone_number"];
          
          Get.toNamed(
            Routes.CHAT_SCREEN_ROUTE,
            arguments: [messageThreadId, toPhoneNumber, null]
          );
        } else {
          print("Payload does not contain 'message_thread_id'.");
        }
      } catch (e) {
        print("Error parsing notification payload: $e");
      }
    } else {
      print("Notification payload is null.");
    }
  }

  static void createanddisplaynotification(RemoteMessage message) {
    // Implement this method as needed
  }
}
