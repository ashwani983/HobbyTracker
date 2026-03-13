package com.hobbytracker.wear

import android.content.Intent
import android.util.Log
import com.google.android.gms.wearable.*

class WatchDataService : WearableListenerService() {

    companion object {
        const val TAG = "WatchDataService"
        const val ACTION_HOBBIES_UPDATED = "com.hobbytracker.wear.HOBBIES_UPDATED"
        const val ACTION_TIMER_STATE = "com.hobbytracker.wear.TIMER_STATE"
        const val ACTION_STATS_UPDATED = "com.hobbytracker.wear.STATS_UPDATED"
    }

    override fun onDataChanged(dataEvents: DataEventBuffer) {
        for (event in dataEvents) {
            if (event.type == DataEvent.TYPE_CHANGED) {
                val path = event.dataItem.uri.path ?: continue
                val dataMap = DataMapItem.fromDataItem(event.dataItem).dataMap
                val json = dataMap.getString("json") ?: continue

                Log.d(TAG, "Data changed: $path")

                when (path) {
                    "/hobbies/sync" -> {
                        HobbyStore.hobbiesJson = json
                        sendBroadcast(Intent(ACTION_HOBBIES_UPDATED))
                    }
                    "/stats/daily" -> {
                        HobbyStore.statsJson = json
                        sendBroadcast(Intent(ACTION_STATS_UPDATED))
                    }
                }
            }
        }
    }

    override fun onMessageReceived(messageEvent: MessageEvent) {
        Log.d(TAG, "Message: ${messageEvent.path}")
        when (messageEvent.path) {
            "/timer/state" -> {
                HobbyStore.timerJson = String(messageEvent.data)
                sendBroadcast(Intent(ACTION_TIMER_STATE))
            }
        }
    }
}
