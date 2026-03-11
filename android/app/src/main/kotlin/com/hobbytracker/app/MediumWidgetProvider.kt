package com.hobbytracker.app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class MediumWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_medium)
            val h1 = widgetData.getString("top_hobby_1", "—") ?: "—"
            val h2 = widgetData.getString("top_hobby_2", "—") ?: "—"
            val h3 = widgetData.getString("top_hobby_3", "—") ?: "—"

            views.setTextViewText(R.id.widget_hobby1, "1. $h1")
            views.setTextViewText(R.id.widget_hobby2, "2. $h2")
            views.setTextViewText(R.id.widget_hobby3, "3. $h3")

            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(android.R.id.background, pendingIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
