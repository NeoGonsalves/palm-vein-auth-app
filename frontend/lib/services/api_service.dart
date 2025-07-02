import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class ApiService {
  static Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String phone,
    required String bioId,
  }) async {
    final uri = Uri.parse('$backendBaseUrl/api/register_user');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'phone': phone,
        'bio_id': bioId,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> validateBio(String bioId) async {
    final uri = Uri.parse('$backendBaseUrl/api/validate_bio');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'bio_id': bioId}),
    );

    return jsonDecode(response.body);
  }

  static Future<String> scanMockBioId() async {
    final uri = Uri.parse('$backendBaseUrl/api/scan_bio_id');

    final response = await http.get(uri);
    final data = jsonDecode(response.body);
    return data['bio_id'];
  }
}
