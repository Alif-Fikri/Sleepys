import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:8000';

  static Future<void> saveName(String name) async {
    final url = Uri.parse('$_baseUrl/save-name/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );

    print('Request sent to $url with name: $name');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to save name');
    }
  }
}
