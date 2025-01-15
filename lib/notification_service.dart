import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:itp_voice/routes.dart';
import 'package:phone_number/phone_number.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

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

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await FirebaseMessaging.instance.requestPermission();

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        createanddisplaynotification(message);
      }
    });

    // Handle background and terminated state messages
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

    try {
      final token = await FirebaseMessaging.instance.getToken();
      print("Firebase Token: $token");
    } catch (e) {
      print("Error getting Firebase token: $e");
    }
  }

  // Background handler function
  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
    if (message.notification != null) {
      // Create the notification with high priority to show in the notification bar
      await createanddisplaynotification(message);
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

  static String extractPhoneNumber(String input) {
    // Regular expression pattern to match phone numbers
    final RegExp phoneNumberPattern = RegExp(r'(\+?\d{1,4}[-\s]?\(?\d{1,5}\)?[-\s]?\d{1,5}[-\s]?\d{1,5}[-\s]?\d{1,5})');
    final match = phoneNumberPattern.firstMatch(input);

    // If a valid phone number is found, return it, otherwise return an empty string
    if (match != null) {
      return match.group(0) ?? '';
    } else {
      return ''; // Return empty string if no phone number is found
    }
  }

  static Future<void> createanddisplaynotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      final androidNotification = message.notification?.android;
      final messageText = message.data['message'] ?? '';  // Extract message text
      // Extract phone number
      final phoneNumber = extractPhoneNumber(notification?.body ?? '');

      if (notification != null && androidNotification != null) {
        const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high, 
          playSound: true,
          icon: '@mipmap/ic_launcher',  
        );

        const NotificationDetails platformDetails = NotificationDetails(
          android: androidDetails,
        );

        
        await _notificationsPlugin.show(
          notification.hashCode,
          phoneNumber,  // Show only the phone number in the title
          messageText,  // Show the message content in the body
          platformDetails,
          payload: jsonEncode(message.data), // Pass data as payload
        );
      }
    } catch (e) {
      print("Error displaying notification: $e");
    }
  }
}
