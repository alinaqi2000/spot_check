package com.spot_check.app.spot_check

import android.Manifest
import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlin.random.Random

class MainActivity: FlutterActivity() {

//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(
//            flutterEngine.dartExecutor.binaryMessenger,
//            "example.com/channel"
//        ).setMethodCallHandler { call, result ->
//            Log.v("Tag", call.method);
//            if (call.method == "getRandomNumber") {
//                val rand = Random.nextInt(100)
//                try {
////                    Settings.System.putInt(
////                        contentResolver,
////                        Settings.Global.AIRPLANE_MODE_ON, if (enabled == 1) 1 else 0
////                    )
//                    val permission: Boolean = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//                        Settings.System.canWrite(context)
//                    } else {
//                        ContextCompat.checkSelfPermission(
//                            context,
//                            Manifest.permission.WRITE_SECURE_SETTINGS
//                        ) == PackageManager.PERMISSION_GRANTED
//                    }
//                    if (permission) {
//                        Settings.Global.putInt(
//                            contentResolver,
//                            Settings.Global.AIRPLANE_MODE_ON, 1
//                        )
//                    } else {
//                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//                            val intent = Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS)
//                            intent.data = Uri.parse("package:" + activity.packageName)
//                          startActivity(
//                                intent
//                            )
//                        } else {
//                            val intent = Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS);
//                            intent.data = Uri.parse("package:" + activity.packageName)
//                           startActivity(
//                                intent
//                            )
//                        }
//                    }
//
//
//                    // val i = Intent(Intent.ACTION_AIRPLANE_MODE_CHANGED)
//                    // i.putExtra("state", enabled)
//                    // sendBroadcast(i)
//                    Log.v("Tag", "Method passed!");
//                } catch (e: ActivityNotFoundException) {
//                    try {
//                        val intent = Intent("android.settings.WIRELESS_SETTINGS")
//                        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
//                        startActivity(intent)
//                    } catch (ex: ActivityNotFoundException) {
//                        Log.v("Tag", "Method failed!");
//                    }
//                }
//
//
//
//
//                result.success(rand)
//            } else {
//                result.notImplemented()
//            }
//        }
//    }

}
