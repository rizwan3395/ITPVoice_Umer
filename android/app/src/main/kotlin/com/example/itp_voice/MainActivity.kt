package com.example.itp_voice

import android.os.Bundle
import android.content.Context
import android.os.PowerManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.ryanheise.audioservice.AudioServiceFragmentActivity

class MainActivity : AudioServiceFragmentActivity() {
    private var wakeLock: PowerManager.WakeLock? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "Voice360::CallScreenWakeLock")
        acquirePartialWakelock() // Acquire on activity creation
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.appicator.itp_voice/wakelock")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "acquirePartialWakelock" -> {
                        acquirePartialWakelock()
                        result.success(null)
                    }
                    "releasePartialWakelock" -> {
                        releasePartialWakelock()
                        result.success(null)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    private fun acquirePartialWakelock() {
        if (wakeLock != null && !wakeLock!!.isHeld) {
            wakeLock!!.acquire(10 * 60 * 1000L) // Acquire the wake lock for 10 minutes
        }
    }

    private fun releasePartialWakelock() {
        if (wakeLock != null && wakeLock!!.isHeld) {
            wakeLock!!.release()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        releasePartialWakelock() // Ensure wake lock is released when activity is destroyed
    }
}
