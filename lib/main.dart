
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:itp_voice/app_theme.dart';
import 'package:itp_voice/controllers/bindings.dart';
import 'package:itp_voice/controllers/mic_controller.dart';
import 'package:itp_voice/locator.dart';
import 'package:itp_voice/notification_service.dart';
import 'package:itp_voice/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  // await setupFlutterNotifications();
  // showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MicServices.instance.init();
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token");

  setupLocator();
   // Initialize SharedPreferences before the app starts
  await Get.putAsync(() async => await SharedPreferences.getInstance());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  LocalNotificationService.initialize();
  initializeTimeZones();
  enableBackgroundExecution();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     
    return ScreenUtilInit(
      designSize: const Size(393, 786),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return DefaultTextStyle(
          style: const TextStyle(
            fontFamily: 'Nato Sans',
          ),
          child: SafeArea(
            child: GetMaterialApp(
              initialBinding: Binding(),
              title: 'ITP Voice',
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: ThemeMode.light,
              debugShowCheckedModeBanner: false,
              // translations: Languages(),
              // fallbackLocale: const Locale('en', 'US'),
              getPages: AppRoutes.routes,
              // initialRoute: Routes.BASE_SCREEN_ROUTE,
              // initialRoute: Routes.LOGIN_SCREEN_ROUTE,
              // get.offAllNamed(Routes.BASE_SCREEN_ROUTE);
              initialRoute: Routes.LOGIN_SCREEN_ROUTE,
            ),
          ),
        );
      },
    );
  }
}



Future<void> enableBackgroundExecution() async {
  disableBatteryOptimizations();
  const androidConfig = FlutterBackgroundAndroidConfig(
    shouldRequestBatteryOptimizationsOff: false,
    notificationTitle: "Your App is Running",
    notificationText: "Maintaining WebSocket Connection",
    notificationImportance: AndroidNotificationImportance.max,
    notificationIcon: AndroidResource(
      name: 'ic_launcher',
      defType: 'mipmap',
    ),
  );
  
  bool hasPermission = await FlutterBackground.initialize(androidConfig: androidConfig);
  if (hasPermission) {
    await FlutterBackground.enableBackgroundExecution();
  }
}


Future<void> disableBatteryOptimizations() async {
  if (await Permission.ignoreBatteryOptimizations.isGranted) {
    return;
  }

  bool success = await Permission.ignoreBatteryOptimizations.request().isGranted;
  if (!success) {
    // Optionally guide the user to manually disable battery optimization for the app
    openAppSettings();
  }
}

