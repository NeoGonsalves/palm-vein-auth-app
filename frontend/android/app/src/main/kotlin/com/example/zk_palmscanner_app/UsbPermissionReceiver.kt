package com.example.zk_palmscanner_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.util.Log

class UsbPermissionReceiver(private val onGranted: (UsbDevice) -> Unit) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "com.zk.palm.USB_PERMISSION") {
            val device = intent.getParcelableExtra<UsbDevice>(UsbManager.EXTRA_DEVICE)
            val granted = intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)
            if (granted && device != null) {
                Log.d("USB", "Permission granted for device: ${device.deviceName}")
                onGranted(device)
            } else {
                Log.e("USB", "Permission denied or device is null")
            }
        }
    }
}
