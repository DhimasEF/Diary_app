import 'dart:convert';
import 'dart:html' as html;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

Future<Map<String, String>> getDeviceHeaders() async {
// Future<Map<String, String>> getDeviceHeadersWeb() async {
  final info = await PackageInfo.fromPlatform();

  String ip = 'unknown';
  try {
    final res = await http
        .get(Uri.parse('https://api.ipify.org?format=json'))
        .timeout(const Duration(seconds: 3));
    ip = jsonDecode(res.body)['ip'];
  } catch (_) {}

  return {
    'X-Device-Model': html.window.navigator.platform ?? 'web',
    'X-OS': 'web',
    'X-OS-Version': html.window.navigator.userAgent,
    'X-App-Version': info.version,
    'X-Device-ID': html.window.navigator.userAgent.hashCode.toString(),
    'X-Client-IP': ip, // ❌ jangan dipercaya backend
  };
}
