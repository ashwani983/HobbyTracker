package com.hobbytracker.wear

import android.content.Context
import android.content.SharedPreferences

object HobbyStore {
    private const val PREFS = "hobby_tracker_wear"

    private var prefs: SharedPreferences? = null

    fun init(context: Context) {
        prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
    }

    var hobbiesJson: String
        get() = prefs?.getString("hobbies", "[]") ?: "[]"
        set(value) { prefs?.edit()?.putString("hobbies", value)?.apply() }

    var timerJson: String
        get() = prefs?.getString("timer", "{}") ?: "{}"
        set(value) { prefs?.edit()?.putString("timer", value)?.apply() }

    var statsJson: String
        get() = prefs?.getString("stats", "{}") ?: "{}"
        set(value) { prefs?.edit()?.putString("stats", value)?.apply() }

    // Offline timer storage for when phone is unreachable
    var pendingTimerData: String?
        get() = prefs?.getString("pending_timer", null)
        set(value) {
            if (value == null) prefs?.edit()?.remove("pending_timer")?.apply()
            else prefs?.edit()?.putString("pending_timer", value)?.apply()
        }
}
