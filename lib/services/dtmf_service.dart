import 'package:flutter/services.dart';

class DtmfService {
  static const MethodChannel _channel = MethodChannel('dtmf_channel');

  static Future<void> playTone({
    required String digits,
    int durationMs = 500,
    double volume = 0.8,
    double samplingRate = 8000.0,
  }) async {
    try {
      await _channel.invokeMethod('playTone', {
        'digits': digits,
        'durationMs': durationMs,
        'volume': volume,
        'samplingRate': samplingRate,
      });
    } on PlatformException catch (e) {
      print("Failed to play DTMF tone: '${e.message}'.");
    }
  }
}