package com.example.flutter_application_1

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import android.telephony.SmsMessage
import io.flutter.plugin.common.MethodChannel

class SmsReceiver : BroadcastReceiver() {

    companion object {
        var methodChannel: MethodChannel? = null
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
            val bundle = intent.extras
            if (bundle != null) {
                val pdus = bundle.get("pdus") as Array<*>
                val messages = pdus.map { pdu ->
                    SmsMessage.createFromPdu(pdu as ByteArray)
                }

                val otpMessage = messages.joinToString("") { it.messageBody }

                methodChannel?.invokeMethod("onOtpReceived", otpMessage)
            }
        }
    }
}
