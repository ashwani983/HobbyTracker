package com.hobbytracker.app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class HobbyWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_hobby)
            val name = widgetData.getString("hobby_widget_name", "Hobby") ?: "Hobby"
            val weekly = widgetData.getString("hobby_widget_weekly", "0 min") ?: "0 min"

            views.setTextViewText(R.id.hobby_name, name)
            views.setTextViewText(R.id.hobby_weekly, "$weekly this week")

            val intent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(android.R.id.background, pendingIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
