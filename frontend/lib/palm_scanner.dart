import 'package:flutter/services.dart';

class PalmScanner {
  static const MethodChannel _channel = MethodChannel('zkpalm/scanner');

  static Future<String> startScan() async {
    try {
      final result = await _channel.invokeMethod<String>('startPalmScan');
      return result ?? 'No response from native code';
    } on PlatformException catch (e) {
      return 'PlatformException: ${e.message}';
    } catch (e) {
      return 'Unexpected error: $e';
    }
  }
}
