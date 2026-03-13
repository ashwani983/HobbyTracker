package com.hobbytracker.wear

import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.items
import androidx.wear.compose.material.*
import androidx.wear.compose.navigation.SwipeDismissableNavHost
import androidx.wear.compose.navigation.composable
import androidx.wear.compose.navigation.rememberSwipeDismissableNavController
import com.google.android.gms.wearable.*
import kotlinx.coroutines.*
import kotlinx.coroutines.tasks.await
import org.json.JSONArray
import org.json.JSONObject

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        HobbyStore.init(this)

        setContent {
            val navController = rememberSwipeDismissableNavController()

            MaterialTheme {
                SwipeDismissableNavHost(navController, startDestination = "home") {
                    composable("home") {
                        HomeScreen(
                            onHobbyClick = { hobbyId, hobbyName ->
                                navController.navigate("timer/$hobbyId/$hobbyName")
                            }
                        )
                    }
                    composable("timer/{hobbyId}/{hobbyName}") { backStackEntry ->
                        val hobbyId = backStackEntry.arguments?.getString("hobbyId") ?: ""
                        val hobbyName = backStackEntry.arguments?.getString("hobbyName") ?: ""
                        TimerScreen(hobbyId, hobbyName, this@MainActivity)
                    }
                }
            }
        }

        // Request hobbies from phone on launch
        requestHobbiesFromPhone()
    }

    private fun requestHobbiesFromPhone() {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val nodes = Wearable.getNodeClient(this@MainActivity).connectedNodes.await()
                for (node in nodes) {
                    Wearable.getMessageClient(this@MainActivity)
                        .sendMessage(node.id, "/hobbies/request", byteArrayOf())
                        .await()
                }
            } catch (e: Exception) {
                Log.e("WearMain", "Failed to request hobbies", e)
            }
        }
    }
}

@Composable
fun HomeScreen(onHobbyClick: (String, String) -> Unit) {
    var hobbies by remember { mutableStateOf(parseHobbies()) }
    var stats by remember { mutableStateOf(parseStats()) }

    // Refresh periodically
    LaunchedEffect(Unit) {
        while (true) {
            hobbies = parseHobbies()
            stats = parseStats()
            delay(2000)
        }
    }

    ScalingLazyColumn(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        // Header with stats
        item {
            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                Text("Hobby Tracker", style = MaterialTheme.typography.title3)
                Spacer(Modifier.height(4.dp))
                Text(
                    "🔥 ${stats.first}d  ⏱ ${stats.second}m",
                    fontSize = 12.sp,
                    color = MaterialTheme.colors.secondary,
                )
            }
        }

        if (hobbies.isEmpty()) {
            item {
                Text(
                    "No hobbies synced.\nOpen app on phone.",
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(16.dp),
                )
            }
        }

        items(hobbies) { hobby ->
            Chip(
                onClick = { onHobbyClick(hobby.first, hobby.second) },
                label = { Text(hobby.second) },
                modifier = Modifier.fillMaxWidth().padding(horizontal = 8.dp),
            )
        }
    }
}

@Composable
fun TimerScreen(hobbyId: String, hobbyName: String, activity: ComponentActivity) {
    var elapsedSeconds by remember { mutableIntStateOf(0) }
    var isRunning by remember { mutableStateOf(false) }
    val scope = rememberCoroutineScope()

    // Timer tick
    LaunchedEffect(isRunning) {
        while (isRunning) {
            delay(1000)
            elapsedSeconds++
        }
    }

    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
    ) {
        Text(hobbyName, style = MaterialTheme.typography.title3)
        Spacer(Modifier.height(8.dp))
        Text(
            formatTime(elapsedSeconds),
            fontSize = 32.sp,
        )
        Spacer(Modifier.height(12.dp))

        if (!isRunning) {
            Button(onClick = {
                isRunning = true
                scope.launch(Dispatchers.IO) {
                    sendTimerCommand(activity, hobbyId, hobbyName, true, elapsedSeconds)
                }
            }) {
                Text("Start")
            }
        } else {
            Button(
                onClick = {
                    isRunning = false
                    scope.launch(Dispatchers.IO) {
                        sendTimerStopped(activity, hobbyId, hobbyName, elapsedSeconds)
                    }
                },
                colors = ButtonDefaults.buttonColors(backgroundColor = MaterialTheme.colors.error),
            ) {
                Text("Stop")
            }
        }
    }
}

private fun formatTime(seconds: Int): String {
    val h = seconds / 3600
    val m = (seconds % 3600) / 60
    val s = seconds % 60
    return if (h > 0) "%d:%02d:%02d".format(h, m, s) else "%02d:%02d".format(m, s)
}

private fun parseHobbies(): List<Pair<String, String>> {
    return try {
        val arr = JSONArray(HobbyStore.hobbiesJson)
        (0 until arr.length()).map { i ->
            val obj = arr.getJSONObject(i)
            Pair(obj.getString("id"), obj.getString("name"))
        }
    } catch (_: Exception) { emptyList() }
}

private fun parseStats(): Pair<Int, Int> {
    return try {
        val obj = JSONObject(HobbyStore.statsJson)
        Pair(obj.optInt("currentStreak", 0), obj.optInt("totalMinutesToday", 0))
    } catch (_: Exception) { Pair(0, 0) }
}

private suspend fun sendTimerCommand(
    activity: ComponentActivity, hobbyId: String, hobbyName: String,
    isRunning: Boolean, elapsed: Int
) {
    val json = JSONObject().apply {
        put("hobbyId", hobbyId)
        put("hobbyName", hobbyName)
        put("isRunning", isRunning)
        put("elapsedSeconds", elapsed)
    }.toString()

    try {
        val nodes = Wearable.getNodeClient(activity).connectedNodes.await()
        for (node in nodes) {
            Wearable.getMessageClient(activity)
                .sendMessage(node.id, "/timer/start", json.toByteArray())
                .await()
        }
    } catch (e: Exception) {
        Log.e("WearTimer", "Failed to send timer command", e)
    }
}

private suspend fun sendTimerStopped(
    activity: ComponentActivity, hobbyId: String, hobbyName: String, elapsed: Int
) {
    val json = JSONObject().apply {
        put("hobbyId", hobbyId)
        put("hobbyName", hobbyName)
        put("elapsedSeconds", elapsed)
    }.toString()

    try {
        val nodes = Wearable.getNodeClient(activity).connectedNodes.await()
        if (nodes.isEmpty()) {
            // Phone unreachable — store locally for later sync
            HobbyStore.pendingTimerData = json
            return
        }
        for (node in nodes) {
            Wearable.getMessageClient(activity)
                .sendMessage(node.id, "/timer/stop", json.toByteArray())
                .await()
        }
        HobbyStore.pendingTimerData = null
    } catch (e: Exception) {
        // Store offline
        HobbyStore.pendingTimerData = json
        Log.e("WearTimer", "Phone unreachable, stored locally", e)
    }
}
