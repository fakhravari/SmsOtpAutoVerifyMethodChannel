import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SmsReceiverScreen(),
    );
  }
}

class SmsReceiverScreen extends StatefulWidget {
  @override
  _SmsReceiverScreenState createState() => _SmsReceiverScreenState();
}

class _SmsReceiverScreenState extends State<SmsReceiverScreen> {
  static const platform = MethodChannel('sms_receiver');
  String _otpCode = "منتظر دریافت OTP...";

  @override
  void initState() {
    super.initState();
    _checkSmsPermission();
    _setMethodCallHandler();
  }

  Future<void> _checkSmsPermission() async {
    try {
      final bool permissionGranted =
          await platform.invokeMethod('checkSmsPermission');
      if (!permissionGranted) {
        setState(() {
          _otpCode = "دسترسی پیامک داده نشده است!";
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _otpCode = "خطا در بررسی دسترسی: ${e.message}";
      });
    }
  }

  void _setMethodCallHandler() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "onOtpReceived") {
        setState(() {
          _otpCode = "OTP دریافت شد: ${call.arguments}";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("دریافت OTP")),
      body: Center(
        child: Text(
          _otpCode,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
