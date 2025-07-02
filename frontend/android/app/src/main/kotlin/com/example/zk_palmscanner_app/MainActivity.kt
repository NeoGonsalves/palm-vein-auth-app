package com.example.zk_palmscanner_app

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "zkpalm/scanner"
    private val testMode = true // ✅ Set to false when testing with real hardware
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startPalmScan" -> {
                    pendingResult = result
                    requestUsbPermission(this)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun requestUsbPermission(context: Context) {
        if (testMode) {
            Log.w("USB", "TEST MODE ENABLED: Simulating USB permission granted.")
            simulateUsbGranted(context)
            return
        }

        val usbManager = context.getSystemService(Context.USB_SERVICE) as UsbManager
        val deviceList = usbManager.deviceList

        Log.d("USB", "Device count: ${deviceList.size}")
        for (device in deviceList.values) {
            Log.d("USB", "Found device: VID=${device.vendorId}, PID=${device.productId}")
            if (device.vendorId == 0x1b55 && device.productId == 0x0700) {
                val permissionIntent = PendingIntent.getBroadcast(
                    context,
                    0,
                    Intent("com.zk.palm.USB_PERMISSION"),
                    PendingIntent.FLAG_IMMUTABLE
                )

                val receiver = UsbPermissionReceiver { grantedDevice ->
                    Log.d("USB", "USB permission granted. Proceed with SDK init here.")
                    // 🔜 You will initialize ZKPalmApi here when real device is connected
                }

                val filter = IntentFilter("com.zk.palm.USB_PERMISSION")
                registerReceiver(receiver, filter)

                usbManager.requestPermission(device, permissionIntent)
                return
            }
        }

        Log.e("USB", "Palm scanner device not found")
        pendingResult?.success("❌ Palm scanner device not found")
        pendingResult = null
    }

    private fun simulateUsbGranted(context: Context) {
        Log.d("USB", "Simulated: USB permission granted.")
        Log.i("ZKPalm", "Simulated palm scanner initialized and started scanning.")

        val response = """
            ✅ Simulated USB permission granted.
            ✅ SDK initialized (mock).
            ✅ Palm scan started (mock).
        """.trimIndent()

        pendingResult?.success(response)
        pendingResult = null
    }
}
