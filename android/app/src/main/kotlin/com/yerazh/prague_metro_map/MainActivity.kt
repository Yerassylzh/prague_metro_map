package com.yerazh.prague_metro_map

import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "prague_metro_map/app_review"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "openStoreReview" -> result.success(openStoreReview())
                "openUrl" -> {
                    val url = call.argument<String>("url").orEmpty()
                    result.success(openUrl(url))
                }
                "sendEmail" -> {
                    val email = call.argument<String>("email").orEmpty()
                    val subject = call.argument<String>("subject").orEmpty()
                    result.success(sendEmail(email, subject))
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun openStoreReview(): Boolean {
        val packageName = applicationContext.packageName
        val marketIntent = Intent(
            Intent.ACTION_VIEW,
            Uri.parse("market://details?id=$packageName")
        ).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        return try {
            startActivity(marketIntent)
            true
        } catch (_: ActivityNotFoundException) {
            openStoreReviewInBrowser(packageName)
        }
    }

    private fun openStoreReviewInBrowser(packageName: String): Boolean {
        val webIntent = Intent(
            Intent.ACTION_VIEW,
            Uri.parse("https://play.google.com/store/apps/details?id=$packageName")
        ).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        return try {
            startActivity(webIntent)
            true
        } catch (_: ActivityNotFoundException) {
            false
        }
    }

    private fun openUrl(url: String): Boolean {
        if (url.isBlank()) return false

        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url)).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        return try {
            startActivity(intent)
            true
        } catch (_: ActivityNotFoundException) {
            false
        }
    }

    private fun sendEmail(email: String, subject: String): Boolean {
        if (email.isBlank()) return false

        val uri = Uri.parse(
            "mailto:${Uri.encode(email)}?subject=${Uri.encode(subject)}"
        )
        val intent = Intent(Intent.ACTION_SENDTO, uri).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        return try {
            startActivity(intent)
            true
        } catch (_: ActivityNotFoundException) {
            false
        }
    }
}
