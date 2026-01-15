import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../utils/device_context.dart';

class ApiService {
  // static const baseUrl = 'http://192.168.6.16:8000';
  static const baseUrl = 'http://10.0.2.2:8000';
  // =========================
  // COMMON HEADERS
  // =========================
  static Future<Map<String, String>> _headers() async {
    final deviceHeaders = await getDeviceHeaders();
    return {
      'Content-Type': 'application/json',
      ...deviceHeaders,
    };
  }

  // =========================
  // GET DIARIES
  // =========================
  static Future<List<dynamic>> getDiaries() async {
    final res = await http.get(
      Uri.parse('$baseUrl/diary'),
      headers: await _headers(),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load diaries');
    }

    final decoded = jsonDecode(res.body);
    return decoded['data'] as List<dynamic>;
  }

  // =========================
  // CREATE DIARY
  // =========================
  static Future<bool> createDiary(
    String title,
    String content,
    DateTime date,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/diary/create'),
      headers: await _headers(),
      body: jsonEncode({
        'diary_date': DateFormat('yyyy-MM-dd').format(date),
        'title': title,
        'content': content,
      }),
    );

    return response.statusCode == 200;
  }

  // =========================
  // UPDATE DIARY
  // =========================
  static Future<bool> updateDiary(
    int id,
    String title,
    String content,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/diary/$id'),
      headers: await _headers(),
      body: jsonEncode({
        'title': title,
        'content': content,
      }),
    );

    return response.statusCode == 200;
  }

  // =========================
  // DELETE DIARY
  // =========================
  static Future<bool> deleteDiary(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/diary/$id'),
      headers: await _headers(),
    );

    return response.statusCode == 200;
  }
}


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:flutter/foundation.dart';

// import '../utils/device_context_mobile.dart';
// import '../utils/device_context_web.dart';

// class ApiService {
//   static const baseUrl = 'http://10.0.2.2:8000';

//   // =========================
//   // COMMON HEADERS (FINAL)
//   // =========================
//   static Future<Map<String, String>> _headers() async {
//     Map<String, String> deviceHeaders;

//     if (kIsWeb) {
//       deviceHeaders = await getDeviceHeadersWeb();
//     } else {
//       deviceHeaders = await getDeviceHeadersMobile();
//     }

//     return {
//       'Content-Type': 'application/json',
//       ...deviceHeaders,
//     };
//   }

//   // =========================
//   // GET DIARIES
//   // =========================
//   static Future<List<dynamic>> getDiaries() async {
//     final res = await http.get(
//       Uri.parse('$baseUrl/diary'),
//       headers: await _headers(),
//     );

//     if (res.statusCode != 200) {
//       throw Exception('Failed to load diaries');
//     }

//     final decoded = jsonDecode(res.body);
//     return decoded['data'] as List<dynamic>;
//   }

//   // =========================
//   // CREATE DIARY
//   // =========================
//   static Future<bool> createDiary(
//     String title,
//     String content,
//     DateTime date,
//   ) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/diary/create'),
//       headers: await _headers(),
//       body: jsonEncode({
//         'diary_date': DateFormat('yyyy-MM-dd').format(date),
//         'title': title,
//         'content': content,
//       }),
//     );

//     return response.statusCode == 200;
//   }

//   // =========================
//   // UPDATE DIARY
//   // =========================
//   static Future<bool> updateDiary(
//     int id,
//     String title,
//     String content,
//   ) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl/diary/$id'),
//       headers: await _headers(),
//       body: jsonEncode({
//         'title': title,
//         'content': content,
//       }),
//     );

//     return response.statusCode == 200;
//   }

//   // =========================
//   // DELETE DIARY
//   // =========================
//   static Future<bool> deleteDiary(int id) async {
//     final response = await http.delete(
//       Uri.parse('$baseUrl/diary/$id'),
//       headers: await _headers(),
//     );

//     return response.statusCode == 200;
//   }
// }
