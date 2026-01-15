import 'dart:io';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

Future<Map<String, String>> getDeviceHeaders() async {
// Future<Map<String, String>> getDeviceHeadersMobile() async {
  final info = await PackageInfo.fromPlatform();
  final deviceInfo = DeviceInfoPlugin();

  String model = 'unknown';
  String osVersion = 'unknown';
  String ip = 'unknown';

  if (Platform.isAndroid) {
    final a = await deviceInfo.androidInfo;
    model = a.model;
    osVersion = a.version.release;
  } else if (Platform.isIOS) {
    final i = await deviceInfo.iosInfo;
    model = i.utsname.machine;       // ✅ non-null
    osVersion = i.systemVersion;     // ✅ non-null
  }

  // ⚠️ IP hanya metadata tambahan
  try {
    final res = await http
        .get(Uri.parse('https://api.ipify.org?format=json'))
        .timeout(const Duration(seconds: 3));
    ip = jsonDecode(res.body)['ip'];
  } catch (_) {
    // emulator / offline → aman diabaikan
  }

  return {
    'X-Device-Model': model,
    'X-OS': Platform.operatingSystem,
    'X-OS-Version': osVersion,
    'X-App-Version': info.version,
    'X-Device-ID': '${Platform.operatingSystem}_$model',
    'X-Client-IP': ip, // optional, backend jangan percaya
  };
}
