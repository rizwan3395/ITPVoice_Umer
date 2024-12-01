package com.appicator.itp_voice;

import android.os.PowerManager;
import android.os.Bundle;
import android.content.Context;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import com.ryanheise.audioservice.AudioServiceFragmentActivity;

public class MainActivity extends AudioServiceFragmentActivity {
    private static final String CHANNEL = "com.appicator.itp_voice/wakelock";
    private PowerManager.WakeLock wakeLock;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Initialize WakeLock
        PowerManager powerManager = (PowerManager) getSystemService(Context.POWER_SERVICE);
        if (powerManager != null) {
            wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "Voice360::CallScreenWakeLock");
            acquirePartialWakelock(); // Acquire on activity creation
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                if (call.method.equals("acquirePartialWakelock")) {
                    acquirePartialWakelock();
                    result.success(null);
                } else if (call.method.equals("releasePartialWakelock")) {
                    releasePartialWakelock();
                    result.success(null);
                } else {
                    result.notImplemented();
                }
            });
    }

    private void acquirePartialWakelock() {
        if (wakeLock == null) {
            PowerManager powerManager = (PowerManager) getSystemService(POWER_SERVICE);
            if (powerManager != null) {
                wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "Voice360::PartialWakelock");
            }
        }
        if (wakeLock != null && !wakeLock.isHeld()) {
            wakeLock.acquire(10 * 60 * 1000L); // Acquire the wake lock for 10 minutes
        }
    }

    private void releasePartialWakelock() {
        if (wakeLock != null && wakeLock.isHeld()) {
            wakeLock.release();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        releasePartialWakelock(); // Ensure the wake lock is released when the activity is destroyed
    }
}
