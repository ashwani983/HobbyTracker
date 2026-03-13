package com.hobbytracker.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.util.Log
import com.google.android.gms.wearable.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "com.hobbytracker.app/wearable"
        private const val TAG = "WearMainActivity"
        private const val PATH_HOBBIES = "/hobbies/sync"
        private const val PATH_TIMER_STATE = "/timer/state"
        private const val PATH_DAILY_STATS = "/stats/daily"
    }

    private var methodChannel: MethodChannel? = null

    private val wearReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            when (intent?.action) {
                "com.hobbytracker.WEAR_TIMER_STOPPED" -> {
                    val data = intent.getStringExtra("data") ?: return
                    methodChannel?.invokeMethod("onTimerStopped", data)
                }
                "com.hobbytracker.WEAR_REQUEST_HOBBIES" -> {
                    methodChannel?.invokeMethod("onHobbiesRequested", null)
                }
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "syncHobbies" -> {
                    syncDataItem(PATH_HOBBIES, call.arguments as String)
                    result.success(null)
                }
                "syncTimerState" -> {
                    sendMessage(PATH_TIMER_STATE, call.arguments as String)
                    result.success(null)
                }
                "syncDailyStats" -> {
                    syncDataItem(PATH_DAILY_STATS, call.arguments as String)
                    result.success(null)
                }
                "getConnectedNodes" -> {
                    Wearable.getNodeClient(this).connectedNodes
                        .addOnSuccessListener { nodes ->
                            val arr = org.json.JSONArray()
                            for (node in nodes) {
                                val obj = org.json.JSONObject()
                                obj.put("id", node.id)
                                obj.put("name", node.displayName)
                                arr.put(obj)
                            }
                            result.success(arr.toString())
                        }
                        .addOnFailureListener { result.success("[]") }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val filter = IntentFilter().apply {
            addAction("com.hobbytracker.WEAR_TIMER_STOPPED")
            addAction("com.hobbytracker.WEAR_REQUEST_HOBBIES")
        }
        registerReceiver(wearReceiver, filter, RECEIVER_NOT_EXPORTED)
    }

    override fun onDestroy() {
        unregisterReceiver(wearReceiver)
        super.onDestroy()
    }

    private fun syncDataItem(path: String, jsonData: String) {
        try {
            val putDataReq = PutDataMapRequest.create(path).apply {
                dataMap.putString("json", jsonData)
                dataMap.putLong("timestamp", System.currentTimeMillis())
            }.asPutDataRequest().setUrgent()

            Wearable.getDataClient(this).putDataItem(putDataReq)
                .addOnSuccessListener { Log.d(TAG, "Data synced: $path") }
                .addOnFailureListener { Log.e(TAG, "Data sync failed: $path", it) }
        } catch (e: Exception) {
            Log.e(TAG, "syncDataItem error", e)
        }
    }

    private fun sendMessage(path: String, data: String) {
        try {
            Wearable.getNodeClient(this).connectedNodes
                .addOnSuccessListener { nodes ->
                    for (node in nodes) {
                        Wearable.getMessageClient(this)
                            .sendMessage(node.id, path, data.toByteArray())
                            .addOnSuccessListener { Log.d(TAG, "Message sent to ${node.displayName}") }
                            .addOnFailureListener { Log.e(TAG, "Message failed", it) }
                    }
                }
        } catch (e: Exception) {
            Log.e(TAG, "sendMessage error", e)
        }
    }
}
