package com.appicator.itp_voice;
import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;

public class ForegroundService extends Service {
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // Keep the microphone active
        Log.d("ForegroundService", "Service running...");
        return START_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
