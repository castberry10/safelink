package io.github.castberry10.safelink

import android.content.pm.PackageManager
import android.content.Intent
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "io.github.castberry10.safelink/channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setAsDefaultBrowser" -> setAsDefaultBrowser(result)

                    "getInstalledBrowsers" -> getInstalledBrowsers(result)

                    "openOtherBrowser" -> {
                        val url = call.argument<String>("url")
                        val defaultBrowser = call.argument<String>("defaultBrowser")
                        if (url != null && defaultBrowser != null) {
                            openOtherBrowser(url, defaultBrowser, result)
                        } else {
                            result.error("INVALID_URL", "URL cannot be null", null)
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun setAsDefaultBrowser(result: MethodChannel.Result) {
        try {
            val intent = Intent(Settings.ACTION_MANAGE_DEFAULT_APPS_SETTINGS)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.error("ERROR", "Cannot open default apps settings", e.localizedMessage)
        }
    }

    private fun getInstalledBrowsers(result: MethodChannel.Result) {
        try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("http://"))
            intent.addCategory(Intent.CATEGORY_BROWSABLE)
            val resolveInfos = packageManager.queryIntentActivities(intent, PackageManager.MATCH_ALL)
            val browserList = resolveInfos.map { info ->
                mapOf(
                    "name" to info.loadLabel(packageManager).toString(),
                    "packageName" to info.activityInfo.packageName
                )
            }
            result.success(browserList)
        } catch (e: Exception) {
            result.error("ERROR", "Cannot get installed browsers", e.localizedMessage)
        }
    }

    private fun openOtherBrowser(url: String, defaultBrowser: String, result: MethodChannel.Result) {
        try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
            intent.setPackage(defaultBrowser)
            startActivity(intent)
            result.success(null)
        } catch (e: Exception) {
            result.error("ERROR", "Cannot open other browser", e.localizedMessage)
        }
    }
}