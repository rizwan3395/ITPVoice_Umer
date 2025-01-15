import 'package:flutter/services.dart';

const platform = MethodChannel('com.appicator.itp_voice/wakelock');

Future<void> acquirePartialWakelock() async {
  try {
    await platform.invokeMethod('acquirePartialWakelock');
  } on PlatformException catch (e) {
    print("Failed to acquire partial wakelock: ${e.message}");
  }
}

Future<void> releasePartialWakelock() async {
  try {
    await platform.invokeMethod('releasePartialWakelock');
  } on PlatformException catch (e) {
    print("Failed to release partial wakelock: ${e.message}");
  }
}