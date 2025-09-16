package com.example.itp_voice

import android.os.Bundle
import android.content.Context
import android.os.PowerManager
import android.media.ToneGenerator
import android.media.AudioManager
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.ryanheise.audioservice.AudioServiceFragmentActivity

class MainActivity : AudioServiceFragmentActivity() {
    private var wakeLock: PowerManager.WakeLock? = null
    private var toneGenerator: ToneGenerator? = null
    private val DTMF_CHANNEL = "dtmf_channel"
    private val WAKELOCK_CHANNEL = "com.appicator.itp_voice/wakelock"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "Voice360::CallScreenWakeLock")
        acquirePartialWakelock() // Acquire on activity creation
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Existing WakeLock MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WAKELOCK_CHANNEL)
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

        // New DTMF MethodChannel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DTMF_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "playTone" -> {
                        val digits = call.argument<String>("digits") ?: ""
                        val durationMs = call.argument<Int>("durationMs") ?: 500
                        val volume = call.argument<Double>("volume")?.toFloat() ?: 0.8f
                        val success = playDtmfTones(digits, durationMs, volume)
                        if (success) {
                            result.success(null)
                        } else {
                            result.error("INVALID_DIGIT", "Invalid DTMF digit found in: $digits", null)
                        }
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    private fun acquirePartialWakelock() {
        if (wakeLock != null && !wakeLock!!.isHeld) {
            wakeLock!!.acquire(10 * 60 * 1000L) // 10 minutes
        }
    }

    private fun releasePartialWakelock() {
        if (wakeLock != null && wakeLock!!.isHeld) {
            wakeLock!!.release()
        }
    }

    private fun playDtmfTones(digits: String, durationMs: Int, volume: Float): Boolean {
        toneGenerator = ToneGenerator(AudioManager.STREAM_DTMF, (100 * volume).toInt())
        val handler = Handler(Looper.getMainLooper())

        digits.forEachIndexed { index, digit ->
            val toneType = when (digit) {
                '1' -> ToneGenerator.TONE_DTMF_1
                '2' -> ToneGenerator.TONE_DTMF_2
                '3' -> ToneGenerator.TONE_DTMF_3
                '4' -> ToneGenerator.TONE_DTMF_4
                '5' -> ToneGenerator.TONE_DTMF_5
                '6' -> ToneGenerator.TONE_DTMF_6
                '7' -> ToneGenerator.TONE_DTMF_7
                '8' -> ToneGenerator.TONE_DTMF_8
                '9' -> ToneGenerator.TONE_DTMF_9
                '0' -> ToneGenerator.TONE_DTMF_0
                '*' -> ToneGenerator.TONE_DTMF_S
                '#' -> ToneGenerator.TONE_DTMF_P
                'A' -> ToneGenerator.TONE_DTMF_A
                'B' -> ToneGenerator.TONE_DTMF_B
                'C' -> ToneGenerator.TONE_DTMF_C
                'D' -> ToneGenerator.TONE_DTMF_D
                else -> {
                    return false
                }
            }

            handler.postDelayed({
                toneGenerator?.startTone(toneType, durationMs)
            }, (index * durationMs).toLong())
        }

        // Release toneGenerator after all tones
        handler.postDelayed({
            toneGenerator?.release()
            toneGenerator = null
        }, (digits.length * durationMs).toLong())
        
        return true
    }

    override fun onDestroy() {
        super.onDestroy()
        releasePartialWakelock()
        toneGenerator?.release() // Ensure toneGenerator is released
        toneGenerator = null
    }
}