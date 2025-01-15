import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:itp_voice/controllers/call_screen_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class MicServices {
  MicServices._();

  static final MicServices instance = MicServices._();
  

  // ------------- Service API -------------
  Future<void> _requestPlatformPermissions() async {
    // Android 13+, you need to allow notification permission to display foreground service notification.
    //
    // iOS: If you need notification, ask for permission.
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (Platform.isAndroid) {
      // Android 12+, there are restrictions on starting a foreground service.
      //
      // To restart the service on device reboot or unexpected problem, you need to allow below permission.
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }


    }
  }

  Future<void> _requestActivityPermission() async {
    final Permission permission = Platform.isAndroid
        ? Permission.microphone
        : Permission.microphone;
    if (await permission.isGranted) {
      return;
    }

    final PermissionStatus status = await permission.request();
    if (!status.isGranted) {
      throw Exception(
          'To start Mic Service You have to give permission to access the microphone.');
    }
  }

  void init() {

    FlutterForegroundTask.initCommunicationPort();
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);    
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'mic_service',
        channelName: 'Mic Service',
        onlyAlertOnce: true,
        
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<void> start() async {
    await _requestPlatformPermissions();
    await _requestActivityPermission();
    CallScreenController cs = Get.put(CallScreenController());
    final ServiceRequestResult result =
        await FlutterForegroundTask.startService(
      serviceId: 500,
      notificationTitle: '${cs.call!.remote_identity!}',
      notificationText: 'Ongoing Call',
      callback: startMicService,
    );

    if (result is ServiceRequestFailure) {
      throw result.error;
    }
  }

  Future<void> stop() async {
    final ServiceRequestResult result =
        await FlutterForegroundTask.stopService();

    if (result is ServiceRequestFailure) {
      throw result.error;
    }
  }

  Future<bool> get isRunningService => FlutterForegroundTask.isRunningService;



  void _onReceiveTaskData(Object data) { 
    
  }

}
