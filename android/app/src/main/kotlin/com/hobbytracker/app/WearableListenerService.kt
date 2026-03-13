package com.hobbytracker.app

import android.content.Intent
import android.util.Log
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.MessageEvent

class PhoneWearableService : com.google.android.gms.wearable.WearableListenerService() {

    companion object {
        private const val TAG = "PhoneWearService"
    }

    override fun onMessageReceived(messageEvent: MessageEvent) {
        Log.d(TAG, "Message received: ${messageEvent.path}")
        when (messageEvent.path) {
            "/hobbies/request" -> {
                val intent = Intent("com.hobbytracker.WEAR_REQUEST_HOBBIES")
                sendBroadcast(intent)
            }
            "/timer/stop" -> {
                val data = String(messageEvent.data)
                val intent = Intent("com.hobbytracker.WEAR_TIMER_STOPPED")
                intent.putExtra("data", data)
                sendBroadcast(intent)
            }
        }
    }

    override fun onDataChanged(dataEvents: DataEventBuffer) {
        for (event in dataEvents) {
            if (event.type == DataEvent.TYPE_CHANGED) {
                Log.d(TAG, "Data changed: ${event.dataItem.uri.path}")
            }
        }
    }
}
