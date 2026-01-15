package com.example.solid_qr_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class SolidQrWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                val data = widgetData.getString("latest_qr_data", "No QR Scanned")
                setTextViewText(R.id.widget_data, data)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
